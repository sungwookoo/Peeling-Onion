import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'dart:convert';
import 'dart:core'; // RegExp를 사용하기 위해 추가
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:front/user_provider.dart';

class CustomUser {
  final int? userId;

  CustomUser.fromJson(Map<String, dynamic> json) : userId = json['user_id'];
}

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  // LoginScreen({super.key});
  static String? baseUrl = dotenv.env['baseUrl'];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  String? _verificationId;

  String? _nicknameValidationMessage;
  String? _phoneValidationMessage;
  String? _prevNicknameText;
  String? _authCodeValidationMessage;

  bool _isNicknameValid = true;
  bool _isPhoneValid = true;
  bool _nicknameChanged = true;
  bool _isAuthCodeSent = false;
  bool _isAuthCodeValid = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      if (_nicknameController.text != _prevNicknameText) {
        setState(() {
          _nicknameChanged = true;
          _nicknameValidationMessage = '닉네임 중복 확인을 해주세요.';
          _prevNicknameText = _nicknameController.text;
        });
      }
    });
    _authCodeController.addListener(() {
      setState(() {
        _authCodeValidationMessage = null;
      });
    });
  }

  Future<void> _checkNickname() async {
    // 닉네임이 공백인 경우
    if (_nicknameController.text == '') {
      setState(() {
        _isNicknameValid = false;
        _nicknameValidationMessage = '닉네임을 입력해주세요.';
      });
      return;
    }

    // 정규식을 사용해 8자 이내의 한글 혹은 영문만 허용
    RegExp regExp =
        RegExp(r'^[\u1100-\u11FF\u3130-\u318F\uAC00-\uD7AFa-zA-Z]{1,8}$');
    if (!regExp.hasMatch(_nicknameController.text)) {
      setState(() {
        _isNicknameValid = false;
        _nicknameValidationMessage = '닉네임은 8자 이내의 한글 혹은 영문만 입력 가능합니다.';
      });
      return;
    }

    Future<OAuthToken?> Token = DefaultTokenManager().getToken();
    final accessToken = await Token.then((value) => value?.accessToken);

    print(_nicknameController.text);
    // API 요청을 사용해 닉네임 중복 여부 확인
    print('$baseUrl/user/nickname/duplicate/${_nicknameController.text}');
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/user/nickname/duplicate/${_nicknameController.text}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        String responseBody = response.body;
        bool isNicknameAvailable = responseBody.toLowerCase() == 'false';
        setState(() {
          _isNicknameValid = isNicknameAvailable;
          _nicknameValidationMessage =
              isNicknameAvailable ? '사용할 수 있는 닉네임입니다.' : '이미 존재하는 닉네임입니다.';
          if (isNicknameAvailable) {
            _nicknameChanged = false;
          }
        });
      } else {
        setState(() {
          _isNicknameValid = false;
          _nicknameValidationMessage = '잘못된 요청입니다..';
        });
      }
    } catch (error) {
      print('error발생!! $error');
    }
  }

  Future<void> _sendAuthCode() async {
    if (_phoneNumberController.text == '') {
      setState(() {
        _isPhoneValid = false;
        _phoneValidationMessage = '전화번호를 입력해주세요.';
      });
      return;
    }
    RegExp regExp = RegExp(r'^\d{11}$');
    if (!regExp.hasMatch(_phoneNumberController.text)) {
      setState(() {
        _phoneValidationMessage = '전화번호는 11자리 숫자만 입력 가능합니다.';
      });
      return;
    }

    String authCode = '123456'; // 인증번호 생성 로직 구현 필요
    String message = '회원가입 인증번호: $authCode';
    List<String> recipients = [_phoneNumberController.text];

    // String result =
    //     await FlutterSms.sendSMS(message: message, recipients: recipients)
    //         .catchError((onError) {
    //   print(onError);
    // });

    // print(result);

    FirebaseAuth auth = FirebaseAuth.instance;

    String phoneNumber = _phoneNumberController.text;
    String formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'^0'), '+82');

    await auth.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber, // 입력받은 전화번호
      verificationCompleted: (PhoneAuthCredential credential) async {
        // 자동 인증이 완료된 경우
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // 인증 실패
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        // 인증 코드가 전송된 경우
        setState(() {
          _verificationId = verificationId;
          _isAuthCodeSent = true;

          _checkNickname();
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // 타임아웃 처리
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _checkAuthCode() async {
    if (_authCodeController.text == '') {
      setState(() {
        _isAuthCodeValid = false;
        _authCodeValidationMessage = '잘못 입력하셨습니다.';
      });
      return;
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    // _verificationId 변수가 null일 경우를 체크하는 코드 추가
    if (_verificationId == null) {
      setState(() {
        _isAuthCodeValid = false;
        _authCodeValidationMessage = '인증번호를 먼저 전송해주세요.';
      });
      return;
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: _authCodeController.text);

    try {
      await auth.signInWithCredential(credential);
      setState(() {
        _isAuthCodeValid = true;
      });
    } catch (e) {
      setState(() {
        _isAuthCodeValid = false;
        _authCodeValidationMessage = '잘못 입력하셨습니다.';
      });
    }
  }

  Future<void> _completeSignUp() async {
    AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();

    // 회원가입 완료 처리 및 다음 화면으로 이동
    Map<String, dynamic> data = {
      'nickname': _nicknameController.text,
      'mobile_number': _phoneNumberController.text,
      "kakaoId": tokenInfo.id,
    };
    // Map<String, String> data = {
    //   "nickname": "khryu1",
    //   "mobile_number": "01050429166",
    //   "img_src": "01050429167",
    //   "kakaoId": "2718790468",
    // };

    print(data);

    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);
    print(accessToken);

    http.Response response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(data),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      // 성공적으로 회원가입이 완료된 경우
      print(response.body);
      CustomUser customUser = CustomUser.fromJson(json.decode(response.body));
      Provider.of<UserIdModel>(context, listen: false)
          .setUserId(customUser.userId);
      print('회원가입 완료');
      Navigator.pushNamed(context, '/home');
    } else {
      // 회원가입이 실패한 경우
      print('회원가입 실패: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "회원가입",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Color(0xffA1D57A),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "서비스 이용을 위해서\n",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffA1D57A),
                        ),
                      ),
                      TextSpan(
                        text: "전화번호 인증",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA1D57A),
                        ),
                      ),
                      TextSpan(
                        text: "을 진행해주세요.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffA1D57A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        labelText: '닉네임',
                        hintText: '8자 이내의 한글 혹은 영문',
                        suffixIcon: IconButton(
                          icon: _nicknameChanged
                              ? const Icon(Icons.check, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                          onPressed: _checkNickname,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    if (_nicknameValidationMessage != null)
                      Text(_nicknameValidationMessage!),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: '전화번호',
                        hintText: '숫자 11자리',
                        suffixIcon: ElevatedButton(
                          onPressed: _sendAuthCode,
                          child: Text(_isAuthCodeSent ? '재인증하기' : '인증하기'),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '전화번호를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    if (_phoneValidationMessage != null)
                      Text(_phoneValidationMessage!),
                    const SizedBox(height: 16),
                    if (_isAuthCodeSent)
                      Column(
                        children: [
                          TextFormField(
                            controller: _authCodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '인증번호',
                              hintText: '6자리 숫자',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: _isAuthCodeValid
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                onPressed: _checkAuthCode,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '인증번호를 입력해주세요.';
                              }
                              return null;
                            },
                          ),
                          if (_authCodeValidationMessage != null)
                            Text(_authCodeValidationMessage!),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isNicknameValid &&
                                  _isPhoneValid &&
                                  _isAuthCodeValid
                              ? _completeSignUp
                              : null,
                          child: const Text('회원가입 완료'),
                        ),
                        IconButton(
                          onPressed: () =>
                              {Navigator.pushNamed(context, '/home')},
                          icon: const Icon(Icons.home),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
