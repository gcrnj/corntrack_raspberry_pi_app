import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/failed_upload_data.dart';

class ManualUploadScreen extends ConsumerStatefulWidget {
  final List<FailedUploadData>? failedUploads;
  const ManualUploadScreen({super.key, this.failedUploads});

  @override
  ConsumerState<ManualUploadScreen> createState() => _ManualUploadScreenState();
}

class _ManualUploadScreenState extends ConsumerState<ManualUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Upload'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
