// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';
import 'package:geo_tasks/features/tasks/viewmodels/autentication._view_model.dart';
import 'package:geo_tasks/features/tasks/widgets/profile_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    Future<XFile?> pickOnce() {
      return _imagePicker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 900,
      );
    }

    XFile? pickedFile;
    try {
      pickedFile = await pickOnce();
    } on PlatformException catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      pickedFile = await pickOnce();
    }

    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();
    final avatarBase64 = base64Encode(bytes);

    final authVm = context.read<AuthenticationViewModel>();
    final saved = await authVm.updateProfileAvatar(avatarBase64);
    if (!mounted) return;

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authVm.errorMessage ?? 'Nao foi possivel salvar a foto.',
          ),
        ),
      );
      return;
    }
  }

  Future<void> _openImageOptions() async {
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F7F5),
                    child: Icon(Icons.photo_camera, color: Color(0xFF0B7267)),
                  ),
                  title: const Text('Tirar foto'),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await Future<void>.delayed(
                      const Duration(milliseconds: 300),
                    );
                    if (!mounted) return;
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F7F5),
                    child: Icon(Icons.photo_library, color: Color(0xFF0B7267)),
                  ),
                  title: const Text('Abrir galeria'),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    await Future<void>.delayed(
                      const Duration(milliseconds: 300),
                    );
                    if (!mounted) return;
                    await _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthenticationViewModel>();
    final user = authVm.currentUserData;
    final userName = user?.name ?? 'Usuario';
    final userEmail = (user?.email.trim().isNotEmpty ?? false)
        ? user!.email
        : 'Sem e-mail cadastrado';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
        titleSpacing: 20,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geo Tasks',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B7267),
                height: 1.1,
              ),
            ),
          ],
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E8E7),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ProfileAvatar(
                            radius: 56,
                            imageBase64: user?.avatarBase64,
                            imageUrl: (user?.avatarBase64?.isNotEmpty ?? false)
                                ? null
                                : 'https://avatars.githubusercontent.com/u/12345678?v=4',
                            onEditTap: _openImageOptions,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userEmail,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Configurações de Conta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.notifications),
                            ),
                            title: Text('Notificações'),
                            onTap: () {},
                          ),
                          Divider(),
                          ListTile(
                            leading: CircleAvatar(child: Icon(Icons.lock)),
                            title: Text('Segurança'),
                            onTap: () {},
                          ),
                          Divider(),
                          ListTile(
                            leading: CircleAvatar(child: Icon(Icons.info)),
                            title: Text('Sobre o aplicativo'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: authVm.isLoading
                        ? null
                        : () async {
                            final navigator = Navigator.of(context);
                            await authVm.logout();
                            navigator.pushNamedAndRemoveUntil(
                              AppRoutes.login,
                              (route) => false,
                            );
                          },
                    child: authVm.isLoading
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Text(
                            'Sair',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
