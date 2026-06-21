import 'package:flutter/material.dart';
import 'basics_screen.dart';
import 'file_ops_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Basics Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuCard(
            icon: Icons.widgets_outlined,
            title: 'Basics',
            subtitle: 'Widgets, Layout, State, Cubit',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BasicsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.insert_drive_file_outlined,
            title: 'Files Oeprations',
            subtitle: 'Share ,Copy Files',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FileOpsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}
