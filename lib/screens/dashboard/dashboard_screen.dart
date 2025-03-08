import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_raspberry_pi_app/screens/dashboard/editable_name_widget.dart';
import 'package:corntrack_raspberry_pi_app/screens/failed_uploads_widget/failed_uploads_widget.dart';
import 'package:corntrack_raspberry_pi_app/services/devices_services.dart';
import 'package:corntrack_raspberry_pi_app/utility/icons_paths.dart';
import 'package:corntrack_utils/utils/colors_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/device_details.dart';
import '../../utility/prefsKeys.dart';

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

  @override
  void initState() {
    reloadDeviceDetails();
    super.initState();
  }

  void reloadDeviceDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceDetails = await deviceServices.getDeviceDetails(prefs.getString(PrefKeys.deviceId.name) ?? '');
    ref.read(deviceDetailsProvider.notifier).state = deviceDetails.data;
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
                                  border:  Border.all(
                                    color: semiBlackColor,
                                    width: 2,
                                  ),
                                ),
                                child: deviceDetails == null
                                    ? CircularProgressIndicator()
                                    : EditableNameWidget(
                                        text: deviceDetails.deviceName,
                                        onSubmitted: (newValue) {
                                          deviceServices.editDeviceName(deviceDetails.deviceId, newValue);
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
                                  border:  Border.all(
                                    color: semiBlackColor,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Today'),
                                    Text(
                                      'Aug. 25, 2025',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '08:00am',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          side: BorderSide(
                                              color: semiBlackColor, width: 1),
                                        ),
                                        onPressed: () {
                                          appRouter.go('/dashboard/connection');
                                        },
                                        child: Icon(Icons.settings,
                                            size: 24,
                                            color:
                                                semiBlackColor), // Customize icon
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
                                'Hourly Temperature',
                                onTap: () {
                                  appRouter.go('/dashboard/hourly_temperature', extra: selectedCornPots);
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
                                'Corn Health Status',
                                onTap: () {
                                  appRouter.go('/dashboard/health_status');
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
                                  appRouter.go('/dashboard/water_distribution', extra: selectedCornPots);
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
                                  appRouter.go('/dashboard/soil_moisture_report', extra: selectedCornPots);
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
                    border:  Border.all(
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
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: FailedUploadsWidget()),
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
    print(selectedCornPots);
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
                onTap: () {},
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
    final selectedList =
        List<Pots>.from(ref.read(selectedCornPotProvider)); // Create a new list
    if (selectedList.contains(pot)) {
      selectedList.remove(pot);
    } else if (pot != null) {
      selectedList.add(pot);
    }
    ref.read(selectedCornPotProvider.notifier).state = selectedList;
  }
}
