import 'package:flutter/material.dart';
import 'package:front/screens/alarm_screens/alarm_screen.dart';
import '../screens/postbox_screens/postbox_screen.dart';
import '../screens/home_screens/home_screen.dart';
import '../screens/field_screens/field_screen.dart';
import '../screens/mypage_screens/mypage_screen.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

// 커스텀 stateful 위젯. 나의 페이지를 구분하기 위해 사용
class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;
  // 페이지 종류
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    PackageScreen(),
    FieldScreen(),
    MypageScreen(),
  ];

  // 현재 페이지
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 실제 UI 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // app Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AlarmScreen()));
            },
            icon: Image.asset('assets/icons/noalarm_color.png'),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      // 화면 내용
      body: Container(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      // 네비게이션 바. 커스텀은 여기서
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: const Color.fromRGBO(60, 106, 28, 0.08),
        backgroundColor: const Color.fromRGBO(253, 253, 245, 1),
        // backgroundColor: Colors.green[100],
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/onion_icon.png')),
            label: '내 양파들',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/box_icon.png')),
            label: '받은 택배함',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/sprout_icon.png')),
            label: '내 양파밭',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/mypage_icon.png')),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(fontFamily: 'CookieRun'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'CookieRun'),
      ),
    );
  }
}
