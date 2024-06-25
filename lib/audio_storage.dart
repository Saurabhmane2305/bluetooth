import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioStorage {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      await initRecorder();
    }

    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/Recorded_audio.wav';

    await _recorder.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
    );
  }

  Future<void> stopRecording() async {
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
  }

  Future<void> dispose() async {
    if (_isRecorderInitialized) {
      await _recorder.closeRecorder();
      _isRecorderInitialized = false;
    }
  }

  Future<String> getRecordedFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/Recorded_audio.wav';
  }
}
