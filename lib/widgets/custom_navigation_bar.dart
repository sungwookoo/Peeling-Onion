import 'package:flutter/material.dart';
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
      // app Bar
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
        actions: const [ImageIcon(AssetImage('assets/icons/noalarm.png'))],
      ),
      // 화면 내용
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // 네비게이션 바. 커스텀은 여기서
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

// 네브 바 버튼 구현하는 클래스
// class NavBarButton extends StatelessWidget {
//   final String text;
//   final String icon;
//   final String goalScreen;

//   const NavBarButton({
//     super.key,
//     required this.text,
//     required this.icon,
//     required this.goalScreen,
//   });

//   // 클릭하면 해당 화면으로 이동
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, goalScreen);
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ImageIcon(
//             AssetImage(icon),
//           ),
//           Text(text),
//         ],
//       ),
//     );
//   }
// }

// // 네비게이션 바 구현
// class _NavigateBarState extends State<NavigateBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // padding: EdgeInsets.all(value),
//       color: Colors.green,
//       height: 70,
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           NavBarButton(
//             text: '받은 택배함',
//             icon: 'assets/icons/box_icon.png',
//             goalScreen: '/package',
//           ),
//           NavBarButton(
//             text: '내 양파들',
//             icon: 'assets/icons/onion_icon.png',
//             goalScreen: '/',
//           ),
//           NavBarButton(
//             text: '내 양파밭',
//             icon: 'assets/icons/sprout_icon.png',
//             goalScreen: '/field',
//           ),
//           NavBarButton(
//             text: '마이페이지',
//             icon: 'assets/icons/mypage_icon.png',
//             goalScreen: '/mypage',
//           ),
//         ],
//       ),
//     );
//   }
// }
