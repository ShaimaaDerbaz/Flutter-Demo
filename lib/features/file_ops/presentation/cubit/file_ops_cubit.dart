import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/file_item.dart';
import '../../domain/usecases/pick_file.dart';
import '../../domain/usecases/copy_file.dart';
import '../../domain/usecases/open_file.dart';
import '../../domain/usecases/share_file.dart';
import 'file_ops_state.dart';

class FileOpsCubit extends Cubit<FileOpsState> {
  final PickFile _pickFile;
  final CopyFile _copyFile;
  final OpenFile _openFile;
  final ShareFile _shareFile;

  FileOpsCubit({
    required this._pickFile,
    required this._copyFile,
    required this._openFile,
    required this._shareFile,
  }) : super(const FileOpsState());

  Future<void> pickFile() async {
    emit(state.copyWith(isLoading: true, clearMessage: true));
    try {
      final file = await _pickFile();
      if (file != null) {
        emit(state.copyWith(
          isLoading: false,
          pickedFile: file,
          clearCopiedFile: true,
          message: 'File chosen successfully',
        ));
      } else {
        emit(state.copyWith(isLoading: false, message: 'Cancelled by user'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'Error: $e'));
    }
  }

  Future<void> copyFile() async {
    if (state.pickedFile == null) return;
    emit(state.copyWith(isLoading: true));
    try {
      final copied = await _copyFile(state.pickedFile!);
      emit(state.copyWith(
        isLoading: false,
        copiedFile: copied,
        message: 'Copied to:\n${copied.path}',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'Copy failed: $e'));
    }
  }

  Future<void> openFile(FileItem file) async {
    try {
      final result = await _openFile(file);
      emit(state.copyWith(message: 'Open result: $result'));
    } catch (e) {
      emit(state.copyWith(message: 'Open failed: $e'));
    }
  }

  Future<void> shareFile(FileItem file) async {
    try {
      final result = await _shareFile(file);
      emit(state.copyWith(message: 'Share status: $result'));
    } catch (e) {
      emit(state.copyWith(message: 'Share failed: $e'));
    }
  }
}
