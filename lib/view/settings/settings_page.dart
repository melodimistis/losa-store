import 'package:flutter/material.dart';

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
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('Tentang Aplikasi'),
              subtitle: const Text('Informasi versi dan pengembang'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Losa Store',
                  applicationVersion: '1.0.2',
                  applicationIcon: const Icon(
                    Icons.shopping_bag,
                    size: 48,
                    color: Colors.blue,
                  ),
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Losa Store adalah aplikasi e-commerce modern yang terhubung ke Strapi Cloud Backend.',
                    ),
                  ],
                );
              },
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('Tentang Aplikasi'),
              subtitle: const Text('Informasi versi dan pengembang'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Losa Store',
                  applicationVersion: '1.0.2',
                  applicationIcon: const Icon(
                    Icons.shopping_bag,
                    size: 48,
                    color: Colors.blue,
                  ),
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Losa Store adalah aplikasi e-commerce modern yang terhubung ke Strapi Cloud Backend.',
                    ),
                  ],
                );
              },
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('Tentang Aplikasi'),
              subtitle: const Text('Informasi versi dan pengembang'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Losa Store',
                  applicationVersion: '1.0.2',
                  applicationIcon: const Icon(
                    Icons.shopping_bag,
                    size: 48,
                    color: Colors.blue,
                  ),
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Losa Store adalah aplikasi e-commerce modern yang terhubung ke Strapi Cloud Backend.',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
