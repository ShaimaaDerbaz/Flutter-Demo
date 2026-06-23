import 'package:flutter/material.dart';
import '../features/basics/presentation/screens/basics_screen.dart';
import '../features/file_ops/presentation/screens/file_ops_screen.dart';
import '../features/posts/presentation/screens/posts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuCard(
            icon: Icons.widgets_outlined,
            title: 'Basics',
            subtitle: 'Widgets, Layout, Forms, Lists, Animations, Gestures',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BasicsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.insert_drive_file_outlined,
            title: 'File Operations',
            subtitle: 'Pick, Copy, Open, Share files',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FileOpsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.cloud_outlined,
            title: 'API + Clean Architecture',
            subtitle: 'JSONPlaceholder · Domain / Data / Presentation layers',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostsScreen()),
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
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
