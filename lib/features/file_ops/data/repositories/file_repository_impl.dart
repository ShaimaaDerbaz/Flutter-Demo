import '../../domain/entities/file_item.dart';
import '../../domain/repositories/file_repository.dart';
import '../datasources/file_local_datasource.dart';

class FileRepositoryImpl implements FileRepository {
  final FileLocalDatasource datasource;
  FileRepositoryImpl(this.datasource);

  @override
  Future<FileItem?> pickFile() => datasource.pickFile();

  @override
  Future<FileItem> copyFile(FileItem file) => datasource.copyFile(file);

  @override
  Future<String> openFile(FileItem file) => datasource.openFile(file);

  @override
  Future<String> shareFile(FileItem file) => datasource.shareFile(file);
}
