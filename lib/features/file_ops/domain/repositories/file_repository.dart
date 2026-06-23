import '../entities/file_item.dart';

abstract class FileRepository {
  Future<FileItem?> pickFile();
  Future<FileItem> copyFile(FileItem file);
  Future<String> openFile(FileItem file);
  Future<String> shareFile(FileItem file);
}
