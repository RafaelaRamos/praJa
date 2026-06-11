import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/database/database_helper.dart';

class BootstrapPage extends StatefulWidget {
  const BootstrapPage({super.key});

  @override
  State<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> {
  late final Future<int> _providerCountFuture;

  @override
  void initState() {
    super.initState();
    _providerCountFuture = GetIt.I<DatabaseHelper>().countProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('praJa')),
      body: FutureBuilder<int>(
        future: _providerCountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar banco: ${snapshot.error}'),
            );
          }

          final count = snapshot.data ?? 0;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('praJa', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 16),
                Text(
                  'SQLite inicializado com $count prestadores mock.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Wave 1 concluída — auth no plano 01-02.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
