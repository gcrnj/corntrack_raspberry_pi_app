
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthStatus extends ConsumerStatefulWidget {
  const HealthStatus({super.key});

  @override
  ConsumerState<HealthStatus> createState() => _HealthStatusState();
}

class _HealthStatusState extends ConsumerState<HealthStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Status'),
      ),
    );
  }
}
