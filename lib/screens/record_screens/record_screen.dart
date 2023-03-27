import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:front/services/stt_api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  String _recordFilePath = '';
  late String sttToken;
  late Future<String> _sttMessage;

  @override
  void initState() {
    super.initState();
    sttToken = SttApiService().getSttToken().toString();
    print(sttToken);
    print(
        '------------------------------------------------------------------------------------');
    _myRecorder.openRecorder();
    initializer();
  }

  void initializer() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    await _myRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
    );
    setState(() {
      _recordFilePath = filePath;
    });
  }

  Future<void> stopRecording() async {
    await _myRecorder.stopRecorder();
    sendSttRequest();
  }

  Future<String> sendSttRequest() async {
    Map<String, dynamic> config = {
      'diarization': {
        'use_verification': false,
      },
      'use_multi_channel': false,
      'use_itn': false,
    };

    var configData = jsonEncode(config);
    final File file = File(_recordFilePath);
    final bytes = await file.readAsBytes();
    final url = Uri.parse('https://openapi.vito.ai/v1/transcribe');
    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile.fromBytes('file', bytes));
    request.headers['Authorization'] = 'bearer $sttToken';
    request.fields['config'] = configData;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);
      print(responseData);
    } else {
      print('요청 실패');
      print(response.statusCode);
    }

    return '1';
  }

  @override
  void dispose() {
    _myRecorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                ),
                height: 300,
                width: 350,
                child: const Text(''),
              ),
              const Image(
                image: AssetImage('assets/images/customonion1.png'),
                height: 300,
              ),
              Text('여기에 저장 : $_recordFilePath'),
              ElevatedButton(
                onPressed: () async {
                  if (_myRecorder.isRecording) {
                    await stopRecording();
                    setState(() {});
                  } else {
                    await startRecording();
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(width: 2),
                    backgroundColor: const Color(0xFFFDFDF5),
                    fixedSize: const Size(100, 100)),
                child: _myRecorder.isRecording
                    ? const Icon(
                        Icons.stop,
                        color: Colors.red,
                        size: 70,
                      )
                    : const Icon(
                        Icons.fiber_manual_record,
                        color: Colors.red,
                        size: 70,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
