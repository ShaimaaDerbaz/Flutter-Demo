import '../entities/file_item.dart';
import '../repositories/file_repository.dart';

class OpenFile {
  final FileRepository repository;
  const OpenFile(this.repository);
  Future<String> call(FileItem file) => repository.openFile(file);
}
