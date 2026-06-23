import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/file_item.dart';

abstract class FileLocalDatasource {
  Future<FileItem?> pickFile();
  Future<FileItem> copyFile(FileItem file);
  Future<String> openFile(FileItem file);
  Future<String> shareFile(FileItem file);
}

class FileLocalDatasourceImpl implements FileLocalDatasource {
  @override
  Future<FileItem?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null || result.files.single.path == null) return null;
    final file = File(result.files.single.path!);
    return FileItem(
      path: file.path,
      name: p.basename(file.path),
      sizeInBytes: file.lengthSync(),
    );
  }

  @override
  Future<FileItem> copyFile(FileItem file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newPath = p.join(appDir.path, file.name);
    final copied = await File(file.path).copy(newPath);
    return FileItem(
      path: copied.path,
      name: p.basename(copied.path),
      sizeInBytes: copied.lengthSync(),
    );
  }

  @override
  Future<String> openFile(FileItem file) async {
    final result = await OpenFilex.open(file.path);
    return result.message;
  }

  @override
  Future<String> shareFile(FileItem file) async {
    final result = await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Shared this file'),
    );
    return result.status.name;
  }
}
