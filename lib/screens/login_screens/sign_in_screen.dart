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

  bool _isNicknameValid = false;
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
          _isNicknameValid = false;
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

    // 정규식을 사용해 8자 이내의 한글, 한글 자모음 혹은 영문 소문자만 허용
    RegExp regExp = RegExp(r'^[가-힣ㄱ-ㅎㅏ-ㅣa-z]{1,8}$');

    if (!regExp.hasMatch(_nicknameController.text)) {
      setState(() {
        _isNicknameValid = false;
        _nicknameValidationMessage = '닉네임은 8자 이내의 한글 혹은 영문 소문자만 입력 가능합니다.';
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
          _phoneValidationMessage = null;
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
      final authCredential = await auth.signInWithCredential(credential);
      setState(
        () {
          _isAuthCodeValid = true;
        },
      );
      if (authCredential.user != null) {
        await auth.currentUser?.delete();
        print("auth정보삭제");
        auth.signOut();
        print("phone로그인된것 로그아웃");
      }
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
      //   "img_src": "01050429167",
      "kakaoId": tokenInfo.id,
    };

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
      body: Container(
        color: const Color.fromRGBO(253, 253, 245, 1),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "회원가입",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffA1D57A),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nicknameController,
                                decoration: InputDecoration(
                                  labelText: '닉네임',
                                  hintText: '한글 혹은 영문 소문자(1~8자)',
                                  hintStyle: const TextStyle(fontSize: 14),
                                  labelStyle:
                                      const TextStyle(color: Color(0xffA1D57A)),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffA1D57A)),
                                  ),
                                  suffixIcon: Container(
                                    child: _nicknameChanged
                                        ? ElevatedButton(
                                            onPressed: _checkNickname,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              // minimumSize: const Size(40, 30),
                                              fixedSize: const Size(40, 0),
                                            ),
                                            child: const Text(
                                              '확인',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )
                                        : const Icon(Icons.check,
                                            size: 30, color: Colors.green),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _nicknameValidationMessage!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _nicknameChanged
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        // TextFormField(
                        //   controller: _nicknameController,
                        //   decoration: InputDecoration(
                        //     labelText: '닉네임',
                        //     hintText: '8자 이내의 한글 혹은 영문 소문자',
                        //     suffixIcon: IconButton(
                        //       icon: _nicknameChanged
                        //           ? const Icon(Icons.check, color: Colors.red)
                        //           : const Icon(Icons.check,
                        //               color: Colors.green),
                        //       onPressed: _checkNickname,
                        //     ),
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return '닉네임을 입력해주세요.';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // if (_nicknameValidationMessage != null)
                        //   Text(_nicknameValidationMessage!),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: '전화번호',
                            hintText: '숫자 11자리',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            labelStyle:
                                const TextStyle(color: Color(0xffA1D57A)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffA1D57A)),
                            ),
                            suffixIcon: ElevatedButton(
                              onPressed: _sendAuthCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isAuthCodeSent
                                    ? Colors.grey
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // minimumSize: const Size(40, 30),
                                fixedSize: const Size(40, 0),
                                // padding: const EdgeInsets.all(2),
                              ),
                              child: Text(
                                _isAuthCodeSent ? '재인증' : '인증',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                _phoneValidationMessage!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
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
                                  labelStyle:
                                      const TextStyle(color: Color(0xffA1D57A)),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffA1D57A)),
                                  ),
                                  suffixIcon: Container(
                                      child: _isAuthCodeValid
                                          ? const Icon(Icons.check,
                                              size: 30, color: Colors.green)
                                          : ElevatedButton(
                                              onPressed: _checkAuthCode,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                // minimumSize: const Size(40, 30),
                                                fixedSize: const Size(40, 0),
                                              ),
                                              child: const Text(
                                                '확인',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '인증번호를 입력해주세요.';
                                  }
                                  return null;
                                },
                              ),
                              if (_authCodeValidationMessage != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _authCodeValidationMessage!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isNicknameValid &&
                                        _isPhoneValid &&
                                        _isAuthCodeValid
                                    ? Colors.green
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // minimumSize: const Size(40, 30),
                                // fixedSize: const Size(40, 0),
                              ),
                              child: const Text('회원가입 완료'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
