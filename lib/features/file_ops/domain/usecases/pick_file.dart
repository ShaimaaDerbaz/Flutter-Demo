import '../entities/file_item.dart';
import '../repositories/file_repository.dart';

class PickFile {
  final FileRepository repository;
  const PickFile(this.repository);
  Future<FileItem?> call() => repository.pickFile();
}
