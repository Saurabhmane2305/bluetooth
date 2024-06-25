import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FileTransferManager {
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;

  Future<void> sendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      if (connectedDevice != null && characteristic != null) {
        await characteristic!.write(fileBytes);
      }
    }
  }

  Future<void> receiveFile(BluetoothCharacteristic characteristic) async {
    List<int> fileBytes = await characteristic.read();

    final directory = await getApplicationDocumentsDirectory();
    String filePath =
        '${directory.path}/received_${DateTime.now().millisecondsSinceEpoch}.wav';
    File file = File(filePath);
    await file.writeAsBytes(fileBytes);
  }

  void setCharacteristic(BluetoothCharacteristic char) {
    characteristic = char;
  }
}
