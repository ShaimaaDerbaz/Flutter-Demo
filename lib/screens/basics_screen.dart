import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/counter_cubit.dart';


class BasicsScreen extends StatefulWidget {
  const BasicsScreen({super.key});

  @override
  State<BasicsScreen> createState() => _BasicsScreenState();
}

class _BasicsScreenState extends State<BasicsScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _greeting = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateGreeting() {
    setState(() {
      _greeting = _nameController.text.isEmpty
          ? ''
          : 'Welcome to:${_nameController.text} 👋';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basica')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionTitle('1. TextField و state Listening'),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateGreeting(),
            ),
            const SizedBox(height: 8),
            if (_greeting.isNotEmpty)
              Text(
                _greeting,
                style: Theme.of(context).textTheme.titleMedium,
              ),

            const SizedBox(height: 24),

            const _SectionTitle('2. Row و Container'),
            const Row(
              children: [
                Expanded(child: _ColorBox(color: Colors.indigo, label: 'Box 1')),
                SizedBox(width: 8),
                Expanded(child: _ColorBox(color: Colors.teal, label: 'Box 2')),
                SizedBox(width: 8),
                Expanded(child: _ColorBox(color: Colors.orange, label: 'Box 3')),
              ],
            ),

            const SizedBox(height: 24),

            const _SectionTitle('3. State Management بالـ Cubit'),
            BlocProvider(
              create: (_) => CounterCubit(),
              child: const _CounterWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  final String label;
  const _ColorBox({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      alignment: Alignment.center,
      child: Text(label, style: TextStyle(color: color)),
    );
  }
}

class _CounterWidget extends StatelessWidget {
  const _CounterWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          BlocBuilder<CounterCubit, int>(
            builder: (context, count) {
              return Text(
                '$count',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: () => context.read<CounterCubit>().decrement(),
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: () => context.read<CounterCubit>().increment(),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () => context.read<CounterCubit>().reset(),
                child: const Text('Make zero'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
