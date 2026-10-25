import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Umum',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.black38),
            title: const Text('Tentang Aplikasi'),
            subtitle: const Text('Informasi versi dan pengembang'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final info = await PackageInfo.fromPlatform();
              if (!context.mounted) return;
              showAboutDialog(
                context: context,
                applicationName: 'Losa Store',
                applicationVersion: info.version,
                applicationIcon: const Icon(
                  Icons.shopping_bag,
                  size: 48,
                  color: Colors.green,
                ),
                children: const [
                  SizedBox(height: 22),
                  Text(
                    'Losa Store adalah aplikasi e-commerce yang terhubung ke backend Strapi.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
