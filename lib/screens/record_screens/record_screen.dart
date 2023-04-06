import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/models/custom_models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:front/services/stt_api_service.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/upload_file.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordScreen extends StatefulWidget {
  final CustomHomeOnion onion;
  final VoidCallback onUpdate;

  const RecordScreen({super.key, required this.onion, required this.onUpdate});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  String _recordFilePath = '';
  String sttToken = '';
  String _sttMessage = '';
  Timer _timer = Timer(const Duration(days: 1), () {});
  var _time = 180;
  late int _positive;
  late int _negative;
  late int _neutral;
  bool _isfirst = true;
  bool _isThinking = false;
  bool _isListening = false;
  late int _onionId;
  late int _imageId;
  late String _imageSrc;

  @override
  void initState() {
    initializer();
    _onionId = widget.onion.id;
    var img = widget.onion.imgSrc;
    _imageId = int.parse(img[img.length - 5]);
    _imageSrc = 'assets/images/onionbottle/${_imageId}onionbottle.png';
    super.initState();
    _myRecorder.openRecorder();
  }

  void initializer() async {
    final sttresult = await SttApiService().getSttToken();
    setState(() {
      sttToken = sttresult;
      print('sttToken : $sttToken');
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
      _isfirst = false;
      _isThinking = true;
      _recordFilePath = filePath;
    });
  }

  Future<void> stopRecording() async {
    await _myRecorder.stopRecorder();
    final sttText = await sendSttRequest();
    setState(() {
      _sttMessage = sttText;
      _isThinking = false;
      if (_positive >= 70) {
        _imageSrc =
            'assets/images/onionbottle/${_imageId}onionbottle_positive.png';
      } else if (_negative >= 70) {
        _imageSrc =
            'assets/images/onionbottle/${_imageId}onionbottle_negative.png';
      } else {
        _imageSrc = 'assets/images/onionbottle/${_imageId}onionbottle.png';
      }
    });
  }

  Future<String> sendSttRequest() async {
    final config = {
      'diarization': {
        'use_verification': false,
      },
      'use_multi_channel': false,
      'use_itn': false,
      // 'paragraph_splitter': {'min': 1, 'max': 50},
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
      print(responseData);
      while (true) {
        var getResult = await getSTT(responseData['id']);
        if (getResult['status'] == 'completed') {
          List t = getResult['results']['utterances'];
          if (t.isEmpty) {
            return '어떤 말도 하지 않으셨어요!';
          } else {
            await getSentiment(t[0]['msg']);
            return t[0]['msg'];
          }
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

  void _startTimer() async {
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

  Future<void> getSentiment(String message) async {
    final url = Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze');
    final Map<String, String> header = {
      'X-NCP-APIGW-API-KEY-ID': dotenv.get('sentimentId'),
      'X-NCP-APIGW-API-KEY': dotenv.get('sentimentKey'),
      'Content-Type': 'application/json',
    };

    String text = message;
    final data = {'content': text};

    final response =
        await http.post(url, headers: header, body: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        _positive = result['document']['confidence']['positive'].round();
        _negative = result['document']['confidence']['negative'].round();
        _neutral = result['document']['confidence']['neutral'].round();
      });
    } else {
      throw Exception('감정 분석에 실패했어요');
    }
  }

  Future<String> saveRecord() async {
    final file = File(_recordFilePath);
    String resultRecordUrl = await UploadApiService().uploadRecord(file);
    return resultRecordUrl;
  }

  void saveRecordMessage() async {
    String recordUrl = await saveRecord();
    var result = UploadApiService().saveMessage(
        _onionId, recordUrl, _positive, _negative, _neutral, _sttMessage);
    print(result);
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wall_paper.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 350,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      bottom: -10,
                      child: Image(
                        image: AssetImage(
                          'assets/images/shelf.png',
                        ),
                        height: 60,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      child: Image(
                        image: AssetImage(_imageSrc),
                        height: 230,
                      ),
                    ),
                  ],
                ),
              ),
              _isfirst
                  ? Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/letterpaper.png'),
                        fit: BoxFit.fill,
                      )),
                      height: 320,
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '양파 이름 : ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'CookieRun',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  widget.onion.name,
                                  style: const TextStyle(
                                      fontSize: 18, fontFamily: 'CookieRun'),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'To. ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'CookieRun',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${widget.onion.receiverNumber.substring(0, 3)}-${widget.onion.receiverNumber.substring(3, 7)}-${widget.onion.receiverNumber.substring(7)}',
                                  style: const TextStyle(
                                    fontFamily: 'CookieRun',
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'DueDate : ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'CookieRun',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  widget.onion.growDueDate.substring(0, 10),
                                  style: const TextStyle(
                                    fontFamily: 'CookieRun',
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/letterpaper.png'),
                        fit: BoxFit.fill,
                      )),
                      height: 320,
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: _isThinking
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isListening)
                                    const Text(
                                      '양파가 듣고 있습니다.',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'CookieRun',
                                      ),
                                    ),
                                  if (_isListening)
                                    Text(
                                      '${_time ~/ 60} : ${_time % 60}',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'CookieRun',
                                      ),
                                    ),
                                  if (!_isListening)
                                    const Text(
                                      '녹음된 메시지를 분석하고 있습니다.',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'CookieRun',
                                      ),
                                    )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_sttMessage != '어떤 말도 하지 않으셨어요!')
                                    const Text(
                                      '녹음된 메시지',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'CookieRun'),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _sttMessage,
                                    style: const TextStyle(
                                      fontFamily: 'CookieRun',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (_sttMessage != '어떤 말도 하지 않으셨어요!')
                                    Text(
                                      '긍정 : $_positive%, 부정 : $_negative%, 중립 : $_neutral%',
                                      style: const TextStyle(
                                        fontFamily: 'CookieRun',
                                      ),
                                    ),
                                ],
                              ),
                      )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 70,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 40,
                      icon: Image.asset('assets/icons/undoIcon.png'),
                    ),
                  ),
                  // OutlinedButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: const Text('취소'),
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_isThinking) {
                        return;
                      }
                      if (_myRecorder.isRecording) {
                        _stopTimer();
                        setState(() {
                          _isListening = false;
                        });
                        await stopRecording();
                        setState(() {});
                      } else {
                        setState(() {
                          _isListening = true;
                          _imageSrc =
                              'assets/images/onionbottle/${_imageId}onionbottle.png';
                        });
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
                  IconButton(
                    onPressed: () {
                      if (_isListening == true || _isThinking == true) {
                        return;
                      }
                      if (_sttMessage == '' ||
                          _sttMessage == '어떤 말도 하지 않으셨어요!') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('녹음하지 않으셨거나 녹음된 메시지가 올바르지 않아요!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('정말 저장하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  saveRecordMessage();
                                  Navigator.pop(context);
                                },
                                child: const Text('저장'),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    icon: const Image(
                      image: AssetImage('assets/icons/saveIcon.png'),
                    ),
                    iconSize: 60,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
