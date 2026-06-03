import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';

class TaskRepository {
  TaskRepository({
    required String userId,
    FirebaseFirestore? firestore,
  }) : _tasksCollection = (firestore ?? FirebaseFirestore.instance)
           .collection('users')
           .doc(userId)
           .collection('tasks');

  final CollectionReference<Map<String, dynamic>> _tasksCollection;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  void listenToTasks({
    required void Function(List<Task> tasks) onTasks,
    required void Function(Object error) onError,
  }) {
    _subscription?.cancel();
    _subscription = _tasksCollection.orderBy('date').snapshots().listen((snap) {
      try {
        final tasks = snap.docs
            .map((doc) {
              final data = Map<String, dynamic>.from(doc.data());
              data['uid'] = doc.id;
              return Task.fromJson(data);
            })
            .toList(growable: false);

        onTasks(tasks);
      } catch (e) {
        onError(e);
      }
    }, onError: onError);
  }

  Future<void> addTask(Task task) async {
    await _tasksCollection.doc(task.uid).set(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.uid).set(task.toJson());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    await _tasksCollection.doc(task.uid).update({
      'isCompleted': !task.isCompleted,
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
