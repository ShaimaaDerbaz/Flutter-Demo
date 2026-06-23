import '../entities/file_item.dart';
import '../repositories/file_repository.dart';

class ShareFile {
  final FileRepository repository;
  const ShareFile(this.repository);
  Future<String> call(FileItem file) => repository.shareFile(file);
}
