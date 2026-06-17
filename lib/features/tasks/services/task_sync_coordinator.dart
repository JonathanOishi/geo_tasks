import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/repositories/task_repository.dart';
import 'package:geo_tasks_sync_core/geo_tasks_sync_core.dart';

class TaskSyncCoordinator {
  TaskSyncCoordinator({required TaskRepository repository})
    : _queue = MemorySyncQueue(),
      _localStore = _InMemoryTaskStore(),
      _remoteStore = _TaskRepositoryRemoteStore(repository) {
    _engine = SyncEngine(
      queue: _queue,
      localStore: _localStore,
      remoteStore: _remoteStore,
      conflictResolver: const LastWriteWinsResolver(),
    );
  }

  final MemorySyncQueue _queue;
  final _InMemoryTaskStore _localStore;
  final _TaskRepositoryRemoteStore _remoteStore;
  late final SyncEngine _engine;

  Future<void> replaceLocalSnapshot(List<Task> tasks) async {
    await _localStore.replaceAll(tasks);
  }

  Future<void> enqueueUpsert(Task task) async {
    final now = DateTime.now().toUtc();
    await _localStore.upsert(_toTaskRecord(task, now));
    await _queue.enqueue(
      SyncAction(
        id: _buildActionId(task.uid, now),
        taskId: task.uid,
        type: SyncActionType.upsert,
        queuedAt: now,
      ),
    );
    await _engine.processPending(now: now);
  }

  Future<void> enqueueDelete(Task task) async {
    final now = DateTime.now().toUtc();
    await _localStore.delete(task.uid, deletedAt: now);
    await _queue.enqueue(
      SyncAction(
        id: _buildActionId(task.uid, now),
        taskId: task.uid,
        type: SyncActionType.delete,
        queuedAt: now,
      ),
    );
    await _engine.processPending(now: now);
  }

  String _buildActionId(String taskId, DateTime now) {
    return '$taskId-${now.microsecondsSinceEpoch}';
  }

  TaskRecord _toTaskRecord(Task task, DateTime syncUpdatedAt) {
    return TaskRecord(
      id: task.uid,
      updatedAt: syncUpdatedAt,
      data: <String, Object?>{
        ...task.toJson(),
        'syncUpdatedAt': syncUpdatedAt.toIso8601String(),
      },
    );
  }
}

class _InMemoryTaskStore implements LocalTaskStore {
  final Map<String, TaskRecord> _records = <String, TaskRecord>{};

  Future<void> replaceAll(List<Task> tasks) async {
    _records.clear();
    for (final task in tasks) {
      final syncUpdatedAt = DateTime.now().toUtc();
      _records[task.uid] = TaskRecord(
        id: task.uid,
        updatedAt: syncUpdatedAt,
        data: <String, Object?>{
          ...task.toJson(),
          'syncUpdatedAt': syncUpdatedAt.toIso8601String(),
        },
      );
    }
  }

  @override
  Future<void> delete(String id, {DateTime? deletedAt}) async {
    final existing = _records[id];
    if (existing == null) {
      _records[id] = TaskRecord(
        id: id,
        updatedAt: deletedAt ?? DateTime.now().toUtc(),
        deletedAt: deletedAt ?? DateTime.now().toUtc(),
      );
      return;
    }

    _records[id] = TaskRecord(
      id: existing.id,
      updatedAt: deletedAt ?? DateTime.now().toUtc(),
      deletedAt: deletedAt ?? DateTime.now().toUtc(),
      data: existing.data,
    );
  }

  @override
  Future<TaskRecord?> getById(String id) async {
    return _records[id];
  }

  @override
  Future<void> upsert(TaskRecord task) async {
    _records[task.id] = task;
  }
}

class _TaskRepositoryRemoteStore implements RemoteTaskStore {
  _TaskRepositoryRemoteStore(this._repository);

  final TaskRepository _repository;

  @override
  Future<void> delete(String id, {DateTime? deletedAt}) async {
    await _repository.deleteTask(id);
  }

  @override
  Future<TaskRecord?> getById(String id) async {
    final raw = await _repository.fetchTaskRawById(id);
    if (raw == null) {
      return null;
    }

    final updatedAt = _parseSyncUpdatedAt(raw['syncUpdatedAt']);

    return TaskRecord(
      id: id,
      updatedAt: updatedAt,
      data: Map<String, Object?>.from(raw),
      deletedAt: raw['deletedAt'] == null ? null : updatedAt,
    );
  }

  @override
  Future<void> upsert(TaskRecord task) async {
    await _repository.upsertTaskRaw(
      task.id,
      Map<String, dynamic>.from(task.data),
    );
  }

  DateTime _parseSyncUpdatedAt(Object? value) {
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed.toUtc();
      }
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
