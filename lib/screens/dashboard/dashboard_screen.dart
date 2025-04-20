import 'dart:async';

import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_raspberry_pi_app/screens/dashboard/editable_name_widget.dart';
import 'package:corntrack_raspberry_pi_app/screens/failed_uploads_widget/failed_uploads_widget.dart';
import 'package:corntrack_raspberry_pi_app/services/devices_services.dart';
import 'package:corntrack_raspberry_pi_app/services/photos_services.dart';
import 'package:corntrack_raspberry_pi_app/utility/icons_paths.dart';
import 'package:corntrack_utils/utils/colors_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_data.dart';
import '../../data/device_details.dart';
import '../../utility/prefsKeys.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

enum Pots {
  pot1,
  pot2,
  pot3;

  String getName() {
    switch (this) {
      case Pots.pot1:
        return 'Pot 1';
      case Pots.pot2:
        return 'Pot 2';
      case Pots.pot3:
        return 'Pot 3';
    }
  }

  int getNumber() {
    switch (this) {
      case Pots.pot1:
        return 1;
      case Pots.pot2:
        return 2;
      case Pots.pot3:
        return 3;
    }
  }

  String getMoistureId() {
    switch (this) {
      case Pots.pot1:
        return 'moisture1';
      case Pots.pot2:
        return 'moisture2';
      case Pots.pot3:
        return 'moisture3';
    }
  }
}

final deviceDetailsProvider = StateProvider<DeviceDetails?>(
  (ref) => null,
);

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final BoxDecoration _containerDecor = BoxDecoration(
    color: lightYellowColor,
    borderRadius: BorderRadius.circular(12),
  );

  final selectedCornPotProvider = StateProvider<List<Pots>>(
    (ref) => Pots.values,
  );

  final EdgeInsets _padding4 = EdgeInsets.all(4);
  final EdgeInsets _padding8 = EdgeInsets.all(8);
  final EdgeInsets _padding8Left =
      EdgeInsets.only(left: 8, top: 8, right: 4, bottom: 8);
  final EdgeInsets _padding8Right =
      EdgeInsets.only(left: 4, top: 8, right: 8, bottom: 8);

  final buttonsPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 22);

  final deviceServices = DevicesServicesFactory.create();

  Timer? _timer;
  late Timer _dateTimeTimer;

  String formattedDate = "";
  String formattedTime = "";

  DevicesServices devicesServices = DevicesServicesFactory.create();
  PhotosServices photosServices = PhotosServiceFactory.create();

  @override
  void initState() {
    reloadDeviceDetails();
    _updateDateTime(); // Update immediately
    _dateTimeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDateTime(); // Update every second
    });
    super.initState();
  }

  void scheduleNextRun(String deviceId) async {
    final intervalMinutes = 5;

    DateTime now = DateTime.now();
    int nextMinutes = ((now.minute ~/ intervalMinutes) + 1) * intervalMinutes;

    if (nextMinutes == 60) {
      nextMinutes = 0;
      now = now.add(Duration(hours: 1));
    }

    DateTime nextRun =
        DateTime(now.year, now.month, now.day, now.hour, nextMinutes);
    Duration initialDelay = nextRun.difference(DateTime.now());

    print("Next scheduled run at: $nextRun");

    // Wait until the next 5-minute mark, then start periodic execution
    print('initialDelay $initialDelay');
    Timer(initialDelay, () async {
      print('=======  Schedule Run  ===========');
      print("1st! ${DateTime.now()}");
      print('=======  Schedule Run  ===========');
      photosServices.postNewPhoto(deviceId);
      final moisture = await devicesServices.postMoistureData(deviceId);
      final ctx = context.mounted ? context : null;
      if(ctx != null && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'New Data: $moisture',
            ),
          ),
        );
      }

      // Schedule periodic runs exactly at every 5-minute mark
      _timer = Timer.periodic(Duration(minutes: intervalMinutes), (timer) {
        DateTime now = DateTime.now();
        int minutes = now.minute;

        print(minutes);
        // Ensure it runs only at 5-minute marks
        if (minutes % intervalMinutes == 0) {
          print('=======  Schedule Run  ===========');
          print("${DateTime.now()}");
          print('=======  Schedule Run  ===========');
          devicesServices.postMoistureData(deviceId);
          photosServices.postNewPhoto(deviceId);
        }
      });
    });
  }

  void reloadDeviceDetails() async {
    var preDeviceId = ref.read(deviceDetailsProvider)?.deviceId ?? '';
    if (preDeviceId == '') {
      // No deviceId
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString(PrefKeys.deviceId.name) ?? '';
      final deviceDetails = await deviceServices.getDeviceDetails(deviceId);
      ref.read(deviceDetailsProvider.notifier).state = deviceDetails.data;
      preDeviceId = deviceDetails.data?.deviceId ?? '';
    }
    print('preDeviceId = ${preDeviceId}');
    print('Got deviceId = ${ref.read(deviceDetailsProvider)?.deviceId}');
    scheduleNextRun(preDeviceId);
  }

  void _updateDateTime() {
    DateTime now = DateTime.now();
    setState(() {
      formattedDate = DateFormat("MMM. dd, yyyy").format(now); // Jan. 20, 2021
      formattedTime = DateFormat("hh:mma").format(now).toLowerCase(); // 08:02am
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCornPots = ref.watch(selectedCornPotProvider);
    final deviceDetails = ref.watch(deviceDetailsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: _padding8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                margin: _padding8,
                                padding: _padding8,
                                decoration: _containerDecor.copyWith(
                                  border: Border.all(
                                    color: semiBlackColor,
                                    width: 2,
                                  ),
                                ),
                                child: deviceDetails == null
                                    ? Center(child: CircularProgressIndicator())
                                    : EditableNameWidget(
                                        text: deviceDetails.deviceName,
                                        deviceId: deviceDetails.deviceId,
                                        onSubmitted: (newValue) {
                                          deviceServices.editDeviceName(
                                              deviceDetails.deviceId, newValue);
                                        },
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                margin: _padding8,
                                padding: _padding8,
                                decoration: _containerDecor.copyWith(
                                  border: Border.all(
                                    color: semiBlackColor,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Today'),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                margin: _padding8,
                                child: _cornsColumn(selectedCornPots),
                              ),
                            ),
                            Expanded(
                              child: _buildClickableContainer(
                                'Hourly Temperature and Humidity',
                                onTap: () {
                                  appRouter.go('/dashboard/hourly_temperature',
                                      extra: selectedCornPots);
                                },
                                margin: _padding8Right,
                                padding: buttonsPadding,
                                isCornPot: false,
                                selected: true,
                                icon: ImageIcon(
                                  AssetImage(temperatureIcon),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildClickableContainer(
                                'Captured Photos',
                                onTap: () {
                                  appRouter.go('/dashboard/captured_photos');
                                },
                                margin: _padding8Left,
                                padding: buttonsPadding,
                                isCornPot: false,
                                selected: true,
                                icon: ImageIcon(
                                  AssetImage(galleryIcon),
                                ),
                              ),
                            ),
                            Expanded(
                              child: _buildClickableContainer(
                                'Smart Farming Dashboard',
                                onTap: () {
                                  appRouter.go('/dashboard/smart-farming',
                                      extra: selectedCornPots);
                                },
                                margin: _padding8Right,
                                padding: buttonsPadding,
                                isCornPot: false,
                                selected: true,
                                icon: ImageIcon(
                                  AssetImage(sadIcon),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildClickableContainer(
                                'Water Distribution',
                                onTap: () {
                                  appRouter.go('/dashboard/water_distribution',
                                      extra: selectedCornPots);
                                },
                                margin: _padding8Left,
                                padding: buttonsPadding,
                                isCornPot: false,
                                selected: true,
                                icon: ImageIcon(
                                  AssetImage(waterIcon),
                                ),
                              ),
                            ),
                            Expanded(
                              child: _buildClickableContainer(
                                'Soil Moisture Report',
                                onTap: () {
                                  appRouter.go(
                                      '/dashboard/soil_moisture_report',
                                      extra: selectedCornPots);
                                },
                                margin: _padding8Right,
                                padding: buttonsPadding,
                                isCornPot: false,
                                selected: true,
                                icon: ImageIcon(
                                  AssetImage(soilMoistureIcon),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  margin: _padding8,
                  padding: _padding8,
                  decoration: _containerDecor.copyWith(
                    border: Border.all(
                      color: semiBlackColor,
                      width: 2,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 277, // based on the
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Failed Uploads',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        deviceDetails?.deviceId != null
                            ? Expanded(
                                child: FailedUploadsWidget(
                                deviceId: deviceDetails?.deviceId ?? '',
                              ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cornsColumn(
    List<Pots> selectedCornPots,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Corn / Pots (At least 1)'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: _buildClickableContainer(Pots.pot1.getName(),
                      isCornPot: true,
                      selected: selectedCornPots.contains(Pots.pot1),
                      pot: Pots.pot1),
                ),
                Expanded(
                  child: _buildClickableContainer(Pots.pot2.getName(),
                      isCornPot: true,
                      selected: selectedCornPots.contains(Pots.pot2),
                      pot: Pots.pot2),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4),
            child: _buildClickableContainer(Pots.pot3.getName(),
                selected: selectedCornPots.contains(Pots.pot3),
                isCornPot: true,
                pot: Pots.pot3),
          ),
        ),
      ],
    );
  }

  Widget _buildClickableContainer(
    String text, {
    ImageIcon? icon,
    void Function()? onTap,
    bool selected = false,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool isCornPot = false,
    Pots? pot,
  }) {
    final color = selected || !isCornPot ? yellowColor : lightYellowColor;
    return Padding(
      padding: margin ?? EdgeInsets.all(0),
      child: Card(
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: !isCornPot ? onTap : () => tapPot(pot),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: padding ?? _padding8,
            decoration: _containerDecor.copyWith(
              color: color,
              border: Border.all(
                color: !isCornPot
                    ? yellowColor
                    : selected
                        ? semiBlackColor
                        : color,
                width: 3,
              ),
            ),
            child: Row(
              mainAxisAlignment: icon != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (icon != null)
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: icon,
                  ),
                if (icon != null)
                  SizedBox(
                    width: 20,
                  ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: isCornPot ? 12 : 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void tapPot(Pots? pot) {
    final selectedList = List<Pots>.from(ref.read(selectedCornPotProvider));
    if (selectedList.contains(pot)) {
      if (selectedList.length > 1) {
        selectedList.remove(pot);
      }
    } else if (pot != null) {
      selectedList.add(pot);
    }
    ref.read(selectedCornPotProvider.notifier).state = selectedList;
  }
}
