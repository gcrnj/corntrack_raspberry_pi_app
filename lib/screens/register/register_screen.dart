import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/services/devices_services.dart';
import 'package:corntrack_raspberry_pi_app/utility/prefsKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final isLoadingProvider = StateProvider<bool>((ref) => true);
  final registeredDeviceDataProvider = StateProvider<ApiData<String?>?>((ref) => null);

  DevicesServices devicesServices = DevicesServicesFactory.create();
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
    final registeredDeviceData = ref.watch(registeredDeviceDataProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(isLoading
                      ? 'Registering this device...'
                      : (registeredDeviceData?.error ?? 'Device failed to register. Please contact the developers.')),
                  FilledButton(
                    onPressed: isLoading ? null : checkRegistration,
                    child: isLoading ? CircularProgressIndicator() : Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkRegistration() async {
    ref.read(isLoadingProvider.notifier).state = true;
    await Future.delayed(Duration(seconds: 5));
    // Register

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? deviceId = prefs.getString(PrefKeys.deviceId.name);
    ApiData<String?> registeredDeviceData = await devicesServices.registerDevice();
    deviceId ??= registeredDeviceData.data;

    if(deviceId != null) {
      print('Saving Device Key - $deviceId');
      await prefs.setString(PrefKeys.deviceId.name, deviceId);
      appRouter.go('/dashboard');
    }
    ref.read(isLoadingProvider.notifier).state = false;
    ref.read(registeredDeviceDataProvider.notifier).state = registeredDeviceData;


  }
}
