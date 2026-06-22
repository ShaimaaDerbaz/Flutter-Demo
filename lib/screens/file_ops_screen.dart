import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
//import 'package:share_plus/share_plus.dart';

class FileOpsScreen extends StatefulWidget {
  const FileOpsScreen({super.key});

  @override
  State<FileOpsScreen> createState() => _FileOpsScreenState();
}

class _FileOpsScreenState extends State<FileOpsScreen> {
  File? _pickedFile;
  File? _copiedFile;
  bool _isLoading = false;
  String? _statusMessage;

  Future<void> _pickFile() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    /*  try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
       
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pickedFile = File(result.files.single.path!);
          _copiedFile = null; 
          _statusMessage = 'File choosen successfully';
        });
      } else {
       
        setState(() => _statusMessage = 'Cancelled by user');
      }
    } catch (e) {
      setState(() => _statusMessage = ' Error : $e');
    } finally {
      setState(() => _isLoading = false);
    }*/
  }

  Future<void> _copyFile() async {
    if (_pickedFile == null) return;

    setState(() => _isLoading = true);

    try {
      final appDir = await getApplicationDocumentsDirectory();

      final fileName = p.basename(_pickedFile!.path);
      final newPath = p.join(appDir.path, fileName);

      final newFile = await _pickedFile!.copy(newPath);

      setState(() {
        _copiedFile = newFile;
        _statusMessage = 'Copy file to:\n${newFile.path}';
      });
    } catch (e) {
      setState(() => _statusMessage = 'Copied file failed : $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openFile(File file) async {
    final result = await OpenFilex.open(file.path);

    setState(() {
      _statusMessage = ' Open Result: ${result.message}';
    });
  }

  Future<void> _shareFile(File file) async {
    //final result = await SharePlus.instance.share(
    //ShareParams(files: [XFile(file.path)], text: 'Shared this file'),
    //);

    setState(() {
      //_statusMessage = 'Share State: ${result.status.name}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Files Operations')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _isLoading ? null : _pickFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Choose File'),
            ),

            const SizedBox(height: 16),

            if (_isLoading) const Center(child: CircularProgressIndicator()),

            if (_pickedFile != null) ...[
              _FileInfoCard(
                title: ' Choosen File',
                file: _pickedFile!,
                actions: [
                  _ActionButton(
                    icon: Icons.copy,
                    label: 'Copy',
                    onTap: _copyFile,
                  ),
                  _ActionButton(
                    icon: Icons.open_in_new,
                    label: 'فتح',
                    onTap: () => _openFile(_pickedFile!),
                  ),
                  _ActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () => _shareFile(_pickedFile!),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            if (_copiedFile != null) ...[
              _FileInfoCard(
                title: 'Copy in Folder',
                file: _copiedFile!,
                color: Colors.teal,
                actions: [
                  _ActionButton(
                    icon: Icons.open_in_new,
                    label: 'Open',
                    onTap: () => _openFile(_copiedFile!),
                  ),
                  _ActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () => _shareFile(_copiedFile!),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_statusMessage!, textAlign: TextAlign.right),
              ),
          ],
        ),
      ),
    );
  }
}

class _FileInfoCard extends StatelessWidget {
  final String title;
  final File file;
  final List<Widget> actions;
  final Color? color;

  const _FileInfoCard({
    required this.title,
    required this.file,
    required this.actions,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    final sizeKb = (file.lengthSync() / 1024).toStringAsFixed(1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: c,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(p.basename(file.path), overflow: TextOverflow.ellipsis),
            Text('$sizeKb KB', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
