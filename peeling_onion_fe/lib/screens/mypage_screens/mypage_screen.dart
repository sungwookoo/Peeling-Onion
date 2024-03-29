import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:front/services/user_api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
// import '../../widgets/loading_rotation.dart';
import 'package:front/widgets/on_will_pop.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  static String? baseUrl = dotenv.env['baseUrl'];
  late Future<Map<String, dynamic>> userInfo; // userInfo 변수 선언
  String? _nicknameValidationMessage;
  String? _prevNicknameText;
  bool _nicknameChanged = true;
  bool _isNicknameValid = true;
  bool _isNicknameEditing = false;
  bool _isPhoneNumberEditing = false;
  bool _isPhoneValid = true;
  bool _isAuthCodeSent = false;
  // Test!!!!!
  // bool _isAuthCodeSent = true;
  bool _isAuthCodeValid = false;
  String? _verificationId;
  String? _phoneValidationMessage;
  String? _authCodeValidationMessage;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInfo();
    _nicknameController.addListener(() {
      if (_nicknameController.text != _prevNicknameText) {
        setState(() {
          _nicknameChanged = true;
          _nicknameValidationMessage = '닉네임 중복 확인을 해주세요.';
          _prevNicknameText = _nicknameController.text;
        });
      }
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
          _nicknameValidationMessage = '잘못된 요청입니다.';
        });
      }
    } catch (error) {
      print('error발생!! $error');
    }
  }

  void getInfo() async {
    userInfo = UserApiService.getUserInfo(context);
    print(userInfo);
  }

  void logOut(context) async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
    Navigator.pushNamed(context, '/');
  }

  void signOut() async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();
    final accessToken = await Token.then((value) => value?.accessToken);

    http.Response response = await http.delete(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('회원탈퇴 시도!!!!');
    print(response.statusCode);
    if (response.statusCode == 200) {
      // 성공적으로 회원가입이 완료된 경우
      print(response.body);
      print('회원탈퇴 완료, 카카오 연동 해제 시도');
      try {
        await UserApi.instance.unlink();
        print('연결 끊기 성공, SDK에서 토큰 삭제');
        Navigator.pushNamed(context, '/');
      } catch (error) {
        print('연결 끊기 실패 $error');
      }
    } else {
      // 회원가입이 실패한 경우
      print('회원탈퇴 실패: ${response.body}');
    }
  }

  void nicknameChange(context) async {
    if (_formKey.currentState!.validate() && _isNicknameValid) {
      Future<OAuthToken?> Token = DefaultTokenManager().getToken();
      final accessToken = await Token.then((value) => value?.accessToken);

      try {
        final response = await http.patch(
          Uri.parse('$baseUrl/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(<String, String>{
            'nickname': _nicknameController.text,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _isNicknameEditing = false;
            _nicknameChanged = false;
          });
          getInfo();
          print('닉네임 수정 완료');
        } else {
          print('닉네임 수정 실패: ${response.body}');
        }
      } catch (error) {
        print('닉네임 수정 에러: $error');
      }
    }
  }

  void phoneNumberChange(context) async {
    if (_isPhoneValid) {
      Future<OAuthToken?> Token = DefaultTokenManager().getToken();
      final accessToken = await Token.then((value) => value?.accessToken);

      try {
        final response = await http.patch(
          Uri.parse('$baseUrl/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(<String, String>{
            'mobile_number': _phoneNumberController.text,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _isPhoneNumberEditing = false;
            _isPhoneValid = false;
            _isAuthCodeSent = false;
            _isAuthCodeValid = false;
          });
          getInfo();
          print('전화번호 완료');
        } else {
          print('전화번호 수정 실패: ${response.body}');
        }
      } catch (error) {
        print('전화번호 수정 에러: $error');
      }
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
        _isPhoneValid = false;
        _phoneValidationMessage = '전화번호는 11자리 숫자만 입력 가능합니다.';
      });
      return;
    }

    setState(() {
      _isAuthCodeValid = false;
    });

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
          _authCodeValidationMessage = '정말 바꾸시겠습니까?';
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

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserIdModel>(context, listen: false).userId;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          color: const Color.fromRGBO(253, 253, 245, 1),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: userInfo, // userInfo 변수 사용
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final nickname = snapshot.data!['nickname'];
                      final phoneNumber = snapshot.data!['mobileNumber'];
                      return Column(
                        children: [
                          const SizedBox(
                            height: 90,
                          ),
                          const Text(
                            "마이페이지",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffA1D57A),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: 270,
                            child: Column(
                              children: [
                                const Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // SizedBox(
                                    //   width: 60,
                                    // ),
                                    Text(
                                      "회원정보 수정",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromRGBO(56, 102, 101, 1)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '닉네임 :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      // '$nickname',
                                      '$nickname',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'NanumMyeongjo',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (!_isNicknameEditing)
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isNicknameEditing =
                                                !_isNicknameEditing;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // 변경된 부분
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          fixedSize: const Size(40, 30),
                                        ),
                                        child: const Text(
                                          '수정',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    if (_isNicknameEditing)
                                      OutlinedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isNicknameEditing =
                                                !_isNicknameEditing;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.green, // 변경된 부분
                                            width: 2.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          fixedSize: const Size(40, 30),
                                        ),
                                        child: const Text(
                                          '취소',
                                          style: TextStyle(
                                            color: Colors.green, // 변경된 부분
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                // const NicknameForm(),
                                if (_isNicknameEditing)
                                  Column(
                                    children: [
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              controller: _nicknameController,
                                              decoration: InputDecoration(
                                                  labelText: '닉네임',
                                                  hintText:
                                                      '한글 혹은 영문 소문자(1~8자)',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 14),
                                                  labelStyle: const TextStyle(
                                                      color: Color(0xffA1D57A)),
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xffA1D57A)),
                                                  ),
                                                  suffixIcon: Container(
                                                    child: _nicknameChanged
                                                        ? ElevatedButton(
                                                            onPressed:
                                                                _checkNickname,
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              // minimumSize: const Size(40, 30),
                                                              fixedSize:
                                                                  const Size(
                                                                      40, 0),
                                                            ),
                                                            child: const Text(
                                                              '확인',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          )
                                                        : ElevatedButton(
                                                            onPressed: () =>
                                                                nicknameChange(
                                                                    context),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  _isAuthCodeSent
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .green,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              // minimumSize: const Size(40, 30),
                                                              fixedSize:
                                                                  const Size(
                                                                      40, 0),
                                                              // padding: const EdgeInsets.all(2),
                                                            ),
                                                            child: const Text(
                                                              '완료',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                  )

                                                  // suffixIcon: IconButton(
                                                  //   icon: _nicknameChanged
                                                  //       ? const Icon(Icons.check,
                                                  //           color: Colors.red)
                                                  //       : ElevatedButton(
                                                  //           onPressed: () =>
                                                  //               nicknameChange(
                                                  //                   context),
                                                  //           style: ElevatedButton
                                                  //               .styleFrom(
                                                  //             backgroundColor:
                                                  //                 Colors.green,
                                                  //             minimumSize:
                                                  //                 const Size(40,
                                                  //                     30), // 이 부분 수정
                                                  //           ),
                                                  //           child: const Text('완료'),
                                                  //         ),
                                                  //   onPressed: _checkNickname,
                                                  // ),
                                                  ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return '닉네임을 입력해주세요.';
                                                }
                                                return null;
                                              },
                                            ),
                                            if (_nicknameValidationMessage !=
                                                null)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                      const SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  ),
                                // const SizedBox(
                                //   height: 8,
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '전화번호 :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      // '$nickname',
                                      '$phoneNumber',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'NanumMyeongjo',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (!_isPhoneNumberEditing)
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isPhoneNumberEditing =
                                                !_isPhoneNumberEditing;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // 변경된 부분
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          fixedSize: const Size(40, 30),
                                        ),
                                        child: const Text(
                                          '수정',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    if (_isPhoneNumberEditing)
                                      OutlinedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isPhoneNumberEditing =
                                                !_isPhoneNumberEditing;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.green, // 변경된 부분
                                            width: 2.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          fixedSize: const Size(40, 30),
                                        ),
                                        child: const Text(
                                          '취소',
                                          style: TextStyle(
                                            color: Colors.green, // 변경된 부분
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (_isPhoneNumberEditing)
                                  TextFormField(
                                    controller: _phoneNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: '바꿀 전화번호',
                                      hintText: '숫자 11자리',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      labelStyle: const TextStyle(
                                          color: Color(0xffA1D57A)),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffA1D57A)),
                                      ),
                                      suffixIcon: ElevatedButton(
                                        onPressed: _sendAuthCode,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _isAuthCodeSent
                                              ? Colors.grey
                                              : Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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

                                if (_phoneValidationMessage != null &&
                                    _isPhoneNumberEditing)
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _phoneValidationMessage!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
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
                                            labelStyle: const TextStyle(
                                                color: Color(0xffA1D57A)),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffA1D57A)),
                                            ),
                                            suffixIcon: Container(
                                              child: !_isAuthCodeValid
                                                  ? ElevatedButton(
                                                      onPressed: _checkAuthCode,
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        // minimumSize: const Size(40, 30),
                                                        fixedSize:
                                                            const Size(40, 0),
                                                      ),
                                                      child: const Text(
                                                        '확인',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    )
                                                  : ElevatedButton(
                                                      onPressed: () =>
                                                          phoneNumberChange(
                                                              context),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            _isAuthCodeSent
                                                                ? Colors.grey
                                                                : Colors.green,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        // minimumSize: const Size(40, 30),
                                                        fixedSize:
                                                            const Size(40, 0),
                                                        // padding: const EdgeInsets.all(2),
                                                      ),
                                                      child: const Text(
                                                        '완료',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                            )

                                            // IconButton(
                                            //   icon: Icon(
                                            //     Icons.check,
                                            //     color: _isAuthCodeValid
                                            //         ? Colors.green
                                            //         : Colors.red,
                                            //   ),
                                            //   onPressed: _checkAuthCode,
                                            // ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  _authCodeValidationMessage!,
                                                  style: TextStyle(
                                                    color: !_isAuthCodeValid
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),

                                // Text('$userId'),
                                const SizedBox(
                                  height: 120,
                                ),
                                // ElevatedButton(
                                //   onPressed: () async {
                                //     shareMessage();
                                //   },
                                //   child: const Text('공유하기'),
                                // ),
                                // IconButton(
                                //   onPressed: () =>
                                //       {Navigator.pushNamed(context, '/signin')},
                                //   icon: const Icon(Icons.home),
                                // ),
                                const Divider(
                                  thickness: 2,
                                  color: Colors.black,
                                ),
                                InkWell(
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "로그아웃",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    logOut(context);
                                  },
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                InkWell(
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "회원탈퇴",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(255, 85, 73, 1),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          // backgroundColor: Colors.green[50],
                                          title: const Text(
                                            '회원탈퇴',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  255, 85, 73, 1),
                                            ),
                                          ),
                                          content:
                                              const Text('정말로 회원탈퇴 하시겠습니까?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                '취소',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                signOut();
                                              },
                                              child: const Text(
                                                '확인',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 85, 73, 1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('에러 발생: ${snapshot.error}');
                    } else {
                      // return const CustomLoadingWidget(
                      //     imagePath: 'assets/images/onion_image.png');
                      return const Text('');
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
