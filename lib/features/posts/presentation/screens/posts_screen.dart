import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/posts_remote_datasource.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../domain/usecases/get_posts.dart';
import '../cubit/posts_cubit.dart';
import '../cubit/posts_state.dart';
import '../widgets/post_card.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostsCubit(
        GetPosts(
          PostsRepositoryImpl(
            PostsRemoteDatasourceImpl(http.Client()),
          ),
        ),
      )..loadPosts(),
      child: const _PostsView(),
    );
  }
}

class _PostsView extends StatelessWidget {
  const _PostsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts — Clean Architecture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () => context.read<PostsCubit>().loadPosts(),
          ),
        ],
      ),
      body: Column(
        children: [
          _ArchitectureBanner(),
          Expanded(
            child: BlocBuilder<PostsCubit, PostsState>(
              builder: (context, state) {
                if (state is PostsInitial || state is PostsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PostsError) {
                  return _ErrorView(
                    message: state.message,
                    onRetry: () => context.read<PostsCubit>().loadPosts(),
                  );
                }
                if (state is PostsLoaded) {
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (_, i) => PostCard(post: state.posts[i]),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchitectureBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        children: [
          _LayerChip('Domain', Colors.deepPurple),
          Icon(Icons.arrow_forward, size: 14),
          _LayerChip('Data', Colors.teal),
          Icon(Icons.arrow_forward, size: 14),
          _LayerChip('Presentation', Colors.indigo),
        ],
      ),
    );
  }
}

class _LayerChip extends StatelessWidget {
  final String label;
  final Color color;
  const _LayerChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      padding: EdgeInsets.zero,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
