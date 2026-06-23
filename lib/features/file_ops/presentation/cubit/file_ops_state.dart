import '../../domain/entities/file_item.dart';

class FileOpsState {
  final bool isLoading;
  final FileItem? pickedFile;
  final FileItem? copiedFile;
  final String? message;

  const FileOpsState({
    this.isLoading = false,
    this.pickedFile,
    this.copiedFile,
    this.message,
  });

  FileOpsState copyWith({
    bool? isLoading,
    FileItem? pickedFile,
    FileItem? copiedFile,
    String? message,
    bool clearPickedFile = false,
    bool clearCopiedFile = false,
    bool clearMessage = false,
  }) {
    return FileOpsState(
      isLoading: isLoading ?? this.isLoading,
      pickedFile: clearPickedFile ? null : (pickedFile ?? this.pickedFile),
      copiedFile: clearCopiedFile ? null : (copiedFile ?? this.copiedFile),
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
