import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';

class FileInfoCard extends StatelessWidget {
  final String title;
  final FileItem file;
  final List<Widget> actions;
  final Color? color;

  const FileInfoCard({
    super.key,
    required this.title,
    required this.file,
    required this.actions,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: c, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(file.name, overflow: TextOverflow.ellipsis),
            Text(
              '${file.sizeKb.toStringAsFixed(1)} KB',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}
