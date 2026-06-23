import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/file_local_datasource.dart';
import '../../data/repositories/file_repository_impl.dart';
import '../../domain/usecases/pick_file.dart';
import '../../domain/usecases/copy_file.dart';
import '../../domain/usecases/open_file.dart';
import '../../domain/usecases/share_file.dart';
import '../cubit/file_ops_cubit.dart';
import '../cubit/file_ops_state.dart';
import '../widgets/action_button.dart';
import '../widgets/file_info_card.dart';

class FileOpsScreen extends StatelessWidget {
  const FileOpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = FileRepositoryImpl(FileLocalDatasourceImpl());
    return BlocProvider(
      create: (_) => FileOpsCubit(
        pickFile: PickFile(repo),
        copyFile: CopyFile(repo),
        openFile: OpenFile(repo),
        shareFile: ShareFile(repo),
      ),
      child: const _FileOpsView(),
    );
  }
}

class _FileOpsView extends StatelessWidget {
  const _FileOpsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Operations')),
      body: BlocBuilder<FileOpsCubit, FileOpsState>(
        builder: (context, state) {
          final cubit = context.read<FileOpsCubit>();
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: state.isLoading ? null : cubit.pickFile,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Choose File'),
                ),
                const SizedBox(height: 16),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (state.pickedFile != null) ...[
                  FileInfoCard(
                    title: 'Chosen File',
                    file: state.pickedFile!,
                    actions: [
                      ActionButton(
                        icon: Icons.copy,
                        label: 'Copy',
                        onTap: cubit.copyFile,
                      ),
                      ActionButton(
                        icon: Icons.open_in_new,
                        label: 'Open',
                        onTap: () => cubit.openFile(state.pickedFile!),
                      ),
                      ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () => cubit.shareFile(state.pickedFile!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                if (state.copiedFile != null) ...[
                  FileInfoCard(
                    title: 'Copied File',
                    file: state.copiedFile!,
                    color: Colors.teal,
                    actions: [
                      ActionButton(
                        icon: Icons.open_in_new,
                        label: 'Open',
                        onTap: () => cubit.openFile(state.copiedFile!),
                      ),
                      ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () => cubit.shareFile(state.copiedFile!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                if (state.message != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(state.message!),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
