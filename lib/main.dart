import 'package:flutter/material.dart';
import 'bluetooth_manager.dart';
import 'audio_processor.dart';
import 'audio_storage.dart';
import 'file_transfer_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothAudioPage(),
    );
  }
}

class BluetoothAudioPage extends StatefulWidget {
  @override
  _BluetoothAudioPageState createState() => _BluetoothAudioPageState();
}

class _BluetoothAudioPageState extends State<BluetoothAudioPage> {
  final BluetoothManager bluetoothManager = BluetoothManager();
  final AudioProcessor audioProcessor = AudioProcessor();
  final AudioStorage audioStorage = AudioStorage();
  final FileTransferManager fileTransferManager = FileTransferManager();
  bool isRecording = false;

  @override
  void initState() {
    super.initState();

    bluetoothManager.scanAndConnect('YourDeviceName');
    audioProcessor.setupWebRTC();
    fileTransferManager.connectedDevice = bluetoothManager.connectedDevice;
  }

  void startRecording() {
    setState(() {
      isRecording = true;
    });
    audioStorage.startRecording();
  }

  void stopRecording() async {
    setState(() {
      isRecording = false;
    });
    await audioStorage.stopRecording();
    String filePath = await audioStorage.getRecordedFilePath();
    print('Audio recorded at: $filePath');
  }

  void sendVoiceNote() {
    fileTransferManager.sendFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Noise Cancellation & File Transfer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              bluetoothManager.connectedDevice == null
                  ? 'Scanning for devices...'
                  : 'Connected to ${bluetoothManager.connectedDevice!.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: Text(
                isRecording ? 'Stop Recording' : 'Start Recording',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendVoiceNote,
              child: Text(
                'Send Voice Note',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
