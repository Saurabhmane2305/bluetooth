import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;

  Future<void> initBluetooth() async {
    await flutterBlue.isOn;
  }

  Future<void> scanAndConnect(String targetDeviceName) async {
    try {
      flutterBlue.startScan(timeout: Duration(seconds: 10));

      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (r.device.name == targetDeviceName) {
            flutterBlue.stopScan();
            connectToDevice(r.device);
            break;
          }
        }
      });
    } catch (e) {
      print('Error during scanning: $e');
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      connectedDevice = device;
      print('Connected to: ${device.name}');

      await discoverServices(device);
    } catch (e) {
      print('Failed to connect to device: $e');
    }
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      print('Discovered services: $services');
    } catch (e) {
      print('Failed to discover services: $e');
    }
  }
}
