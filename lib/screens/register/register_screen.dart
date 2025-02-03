import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final isLoadingProvider = StateProvider<bool>((ref) => true);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkRegistration();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(isLoading
                    ? 'Registering this device...'
                    : 'Device failed to register'),
                FilledButton(
                  onPressed: isLoading ? null : checkRegistration,
                  child: isLoading ? CircularProgressIndicator() : Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkRegistration() async {
    ref.read(isLoadingProvider.notifier).state = true;
    await Future.delayed(Duration(seconds: 5));
    ref.read(isLoadingProvider.notifier).state = false;


  }
}
