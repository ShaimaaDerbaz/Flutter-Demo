import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/counter_cubit.dart';

class BasicsScreen extends StatelessWidget {
  const BasicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Basics'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.widgets_outlined), text: 'Widgets'),
              Tab(icon: Icon(Icons.list_alt_outlined), text: 'Forms & Lists'),
              Tab(icon: Icon(Icons.animation_outlined), text: 'Animations'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_WidgetsTab(), _FormsListsTab(), _AnimationsTab()],
        ),
      ),
    );
  }
}

class _WidgetsTab extends StatefulWidget {
  const _WidgetsTab();

  @override
  State<_WidgetsTab> createState() => _WidgetsTabState();
}

class _WidgetsTabState extends State<_WidgetsTab> {
  final TextEditingController _nameController = TextEditingController();
  String _greeting = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle('1. TextField + setState'),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() {
              _greeting = v.isEmpty ? '' : 'Welcome, $v!';
            }),
          ),
          const SizedBox(height: 8),
          if (_greeting.isNotEmpty)
            Text(_greeting, style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 24),
          const _SectionTitle('2. Row + Container + Expanded'),
          const Row(
            children: [
              Expanded(
                child: _ColorBox(color: Colors.indigo, label: 'Box 1'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ColorBox(color: Colors.teal, label: 'Box 2'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ColorBox(color: Colors.orange, label: 'Box 3'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const _SectionTitle('3. Stack + Positioned'),
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.indigo.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const Positioned(top: 10, left: 10, child: Text('Top-Left')),
                const Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text('Bottom-Right'),
                ),
                const Center(
                  child: Text(
                    'Center',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const _SectionTitle('4. Counter'),
          BlocProvider(
            create: (_) => CounterCubit(),
            child: const _CounterWidget(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TAB 2 — Forms & Lists
// ─────────────────────────────────────────────
class _FormsListsTab extends StatefulWidget {
  const _FormsListsTab();

  @override
  State<_FormsListsTab> createState() => _FormsListsTabState();
}

class _FormsListsTabState extends State<_FormsListsTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _submitted;

  final _fruits = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig'];
  bool _showGrid = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle('5. Form Validation'),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(
                        () => _submitted = 'Logged in as ${_emailCtrl.text}',
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
                if (_submitted != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _submitted!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionTitle(
                _showGrid ? '7. GridView.builder' : '6. ListView.builder',
              ),
              ToggleButtons(
                isSelected: [!_showGrid, _showGrid],
                onPressed: (i) => setState(() => _showGrid = i == 1),
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.view_list),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.grid_view),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 280,
            child: _showGrid
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: _fruits.length,
                    itemBuilder: (_, i) =>
                        _FruitGridTile(fruit: _fruits[i], index: i),
                  )
                : ListView.builder(
                    itemCount: _fruits.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: CircleAvatar(child: Text('${i + 1}')),
                      title: Text(_fruits[i]),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FruitGridTile extends StatelessWidget {
  final String fruit;
  final int index;
  const _FruitGridTile({required this.fruit, required this.index});

  static const _colors = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.brown,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[index % _colors.length];
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            fruit,
            style: TextStyle(fontSize: 11, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TAB 3 — Animations & Gestures
// ─────────────────────────────────────────────
class _AnimationsTab extends StatefulWidget {
  const _AnimationsTab();

  @override
  State<_AnimationsTab> createState() => _AnimationsTabState();
}

class _AnimationsTabState extends State<_AnimationsTab> {
  bool _expanded = false;
  String _lastGesture = 'None';
  bool _loadingFuture = false;
  String? _futureResult;

  Future<String> _fakeApiCall() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data fetched successfully!';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle('8. AnimatedContainer'),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: _expanded ? 140 : 70,
              decoration: BoxDecoration(
                color: _expanded
                    ? Colors.indigo.withValues(alpha: 0.2)
                    : Colors.teal.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(_expanded ? 32 : 8),
                border: Border.all(
                  color: _expanded ? Colors.indigo : Colors.teal,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _expanded ? 'Tap to shrink' : 'Tap to expand',
                style: TextStyle(
                  color: _expanded ? Colors.indigo : Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const _SectionTitle('9. GestureDetector'),
          GestureDetector(
            onTap: () => setState(() => _lastGesture = 'Single Tap'),
            onDoubleTap: () => setState(() => _lastGesture = 'Double Tap'),
            onLongPress: () => setState(() => _lastGesture = 'Long Press'),
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.touch_app_outlined),
                  const SizedBox(height: 4),
                  const Text('Tap / Double-tap / Long-press here'),
                  Text(
                    'Last: $_lastGesture',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          const _SectionTitle('10. FutureBuilder'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (!_loadingFuture && _futureResult == null)
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _loadingFuture = true;
                        _futureResult = null;
                      });
                      _fakeApiCall().then((result) {
                        if (mounted) {
                          setState(() {
                            _loadingFuture = false;
                            _futureResult = result;
                          });
                        }
                      });
                    },
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text('Fetch Data (2s delay)'),
                  ),
                if (_loadingFuture)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Fetching…'),
                    ],
                  ),
                if (_futureResult != null)
                  Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _futureResult!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() => _futureResult = null),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
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
            builder: (context, count) => Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
