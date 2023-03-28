import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  String sttToken = '';
  String _sttMessage = '';
  late Timer _timer;
  var _time = 180;

  @override
  void initState() {
    initializer();
    super.initState();
    _myRecorder.openRecorder();
  }

  void initializer() async {
    final sttresult = await SttApiService().getSttToken();
    setState(() {
      sttToken = sttresult;
    });
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
    final sttText = await sendSttRequest();
    setState(() {
      _sttMessage = sttText;
    });
  }

  Future<String> sendSttRequest() async {
    final config = {
      'diarization': {
        'use_verification': false,
      },
      'use_multi_channel': false,
      'use_itn': false,
    };

    var configData = jsonEncode(config);
    final file = File(_recordFilePath);
    final url = Uri.parse('https://openapi.vito.ai/v1/transcribe');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'bearer $sttToken'
      ..fields['config'] = configData
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);
      while (true) {
        var getResult = await getSTT(responseData['id']);
        if (getResult['status'] == 'completed') {
          List t = getResult['results']['utterances'];
          if (t.isEmpty) {
            return '어떤 말도 하지 않으셨어요!';
          }
          return t[0]['msg'];
        }
      }
    } else {
      throw Exception('요청 실패');
    }
  }

  Future<Map> getSTT(String sttId) async {
    final getSttUrl = 'https://openapi.vito.ai/v1/transcribe/$sttId';
    final response = await http.get(Uri.parse(getSttUrl),
        headers: {'Authorization': 'bearer $sttToken'});

    if (response.statusCode == 200) {
      var results = jsonDecode(response.body);
      return results;
    } else {
      throw Exception('stt 불러오기 실패');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _time--;
      });

      if (_time == 0) {
        setState(() {
          _time = 180;
        });
        _timer.cancel();
      }
    });
  }

  void _stopTimer() {
    setState(() {
      _time = 180;
    });
    _timer.cancel();
  }

  @override
  void dispose() {
    _myRecorder.closeRecorder();
    _timer.cancel();
    super.dispose();
  }

  Future<void> getSentiment() async {
    final url = Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze');
    final Map<String, String> header = {
      'X-NCP-APIGW-API-KEY-ID': dotenv.get('sentimentId'),
      'X-NCP-APIGW-API-KEY': dotenv.get('sentimentKey'),
      'Content-Type': 'application/json',
    };

    String text = '싸늘하다. 가슴에 비수가 날아와 꽂힌다.';
    final data = {'content': text};

    final response =
        await http.post(url, headers: header, body: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result);
    } else {
      print(jsonDecode(response.body));
    }
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
                child: Text(_sttMessage),
              ),
              const Image(
                image: AssetImage('assets/images/customonion1.png'),
                height: 300,
              ),
              Text('여기에 저장 : $_recordFilePath'),
              if (_myRecorder.isRecording)
                Text('${_time ~/ 60} : ${_time % 60}'),
              ElevatedButton(
                onPressed: () async {
                  if (_myRecorder.isRecording) {
                    _stopTimer();
                    await stopRecording();
                    setState(() {});
                  } else {
                    _startTimer();
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
              ),
              ElevatedButton(
                onPressed: () {
                  getSentiment();
                },
                child: const Text('감정분석 요청'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
