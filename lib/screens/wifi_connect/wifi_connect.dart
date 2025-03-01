import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Rpi needs `sudo apt install network-manager`
class WifiConnect extends StatefulWidget {
  const WifiConnect({super.key});

  @override
  State<WifiConnect> createState() => _WifiConnectState();
}

class _WifiConnectState extends State<WifiConnect> {
  List<String> networks = [];
  String selectedSSID = '';
  TextEditingController passwordController = TextEditingController();
  String status = '';

  @override
  void initState() {
    super.initState();
    scanWiFi();
  }

  Future<void> scanWiFi() async {
    try {
      ProcessResult result =
          await Process.run('nmcli', ['-t', '-f', 'SSID', 'dev', 'wifi']);
      List<String> ssids = result.stdout
          .toString()
          .split('\n')
          .where((s) => s.isNotEmpty)
          .toList();
      setState(() {
        networks = ssids.toSet().toList();
        print("Found ${networks.length} wifi's");
      });
    } catch (e) {
      setState(() {
        status = 'Error scanning WiFi: $e';
        print(status);
      });
    }
  }

  Future<void> connectToWiFi() async {
    if (selectedSSID.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        status = 'Please select a network and enter a password';
      });
      return;
    }

    setState(() {
      status = 'Connecting to $selectedSSID...';
    });

    try {
      ProcessResult result;
      if (kIsWeb) {
        setState(() {
          status = "WiFi scanning is not supported on Web.";
        });
        return;
      }

      if (Platform.isWindows) {
        result = await Process.run('netsh', ['wlan', 'show', 'network']);
        networks = parseWindowsWiFi(result.stdout.toString());
      } else if (Platform.isLinux) {
        result = await Process.run('nmcli', ['-t', '-f', 'SSID', 'dev', 'wifi']);
        networks = result.stdout.toString().split('\n').where((s) => s.isNotEmpty).toList();
      } else {
        return;
      }

      setState(() {
        status = result.stdout.toString().contains('successfully')
            ? 'Connected to $selectedSSID'
            : 'Failed to connect: ${result.stderr}';
      });
    } catch (e) {
      setState(() {
        status = 'Error connecting: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connect to WiFi')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Select WiFi Network'),
              value: selectedSSID.isEmpty ? null : selectedSSID,
              onChanged: (value) {
                setState(() {
                  selectedSSID = value ?? '';
                });
              },
              items: networks.map((ssid) {
                return DropdownMenuItem<String>(
                  value: ssid,
                  child: Text(ssid),
                );
              }).toList(),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'WiFi Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectToWiFi,
              child: Text('Connect'),
            ),
            SizedBox(height: 20),
            Text(status, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  List<String> parseWindowsWiFi(String output) {
    RegExp ssidRegex = RegExp(r"SSID \d+ : (.+)");
    return ssidRegex.allMatches(output).map((m) => m.group(1) ?? "").toList();
  }
}
