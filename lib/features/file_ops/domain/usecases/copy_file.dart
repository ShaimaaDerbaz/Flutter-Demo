import '../entities/file_item.dart';
import '../repositories/file_repository.dart';

class CopyFile {
  final FileRepository repository;
  const CopyFile(this.repository);
  Future<FileItem> call(FileItem file) => repository.copyFile(file);
}
