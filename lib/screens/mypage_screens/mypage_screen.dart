import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:front/widgets/kakao_share.dart';
import 'package:front/services/user_api_service.dart';

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
    Navigator.pushNamed(context, '/');
  }

  void nicknameChange() async {
    // // 회원가입 완료 처리 및 다음 화면으로 이동
    // Map<String, dynamic> data = {
    //   'nickname': _nicknameController.text,
    //   'mobile_number': _phoneNumberController.text,
    //   //   "img_src": "01050429167",
    //   "kakaoId": tokenInfo.id,
    // };

    // print(data);

    // Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    // final accessToken = await Token.then((value) => value?.accessToken);
    // print(accessToken);

    // http.Response response = await http.post(
    //   Uri.parse('$baseUrl/user'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $accessToken',
    //   },
    //   body: json.encode(data),
    // );

    // print(response.statusCode);
    // if (response.statusCode == 200) {
    //   // 성공적으로 회원가입이 완료된 경우
    //   print(response.body);
    //   CustomUser customUser = CustomUser.fromJson(json.decode(response.body));
    //   Provider.of<UserIdModel>(context, listen: false)
    //       .setUserId(customUser.userId);
    //   print('회원가입 완료');
    //   Navigator.pushNamed(context, '/home');
    // } else {
    //   // 회원가입이 실패한 경우
    //   print('회원가입 실패: ${response.body}');
    // }
  }

  void showNicknameForm() {
    _isNicknameEditing = !_isNicknameEditing;
    print(_isNicknameEditing);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserIdModel>(context, listen: false).userId;
    return Scaffold(
      body: SingleChildScrollView(
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
                        height: 40,
                      ),
                      const Text(
                        "마이페이지",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA1D57A),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   width: 60,
                          // ),
                          Text(
                            "회원정보수정",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 270,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '닉네임 :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(
                                  // '$nickname',
                                  '$nickname',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isNicknameEditing = !_isNicknameEditing;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isNicknameEditing
                                        ? Colors.grey
                                        : Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(40, 30),
                                  ),
                                  child: Text(_isNicknameEditing ? '취소' : '수정'),
                                )
                              ],
                            ),
                            // const NicknameForm(),
                            if (_isNicknameEditing)
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
                                              ? const Icon(Icons.check,
                                                  color: Colors.red)
                                              : const Icon(Icons.check,
                                                  color: Colors.green),
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
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '전화번호 :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(
                                  // '$nickname',
                                  '$phoneNumber',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isPhoneNumberEditing =
                                          !_isPhoneNumberEditing;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isPhoneNumberEditing
                                        ? Colors.grey
                                        : Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(40, 30),
                                  ),
                                  child:
                                      Text(_isPhoneNumberEditing ? '취소' : '수정'),
                                )
                              ],
                            ),
                            if (_isPhoneNumberEditing) const Text('전화번호 수정수정'),
                            Text('$userId'),
                            Text('$phoneNumber'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          logOut(context);
                        },
                        child: const Text('로그아웃'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          signOut();
                        },
                        child: const Text('회원탈퇴'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          shareMessage();
                        },
                        child: const Text('공유하기'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('에러 발생: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
