import 'package:flutter/material.dart';

class NavigateBar extends StatefulWidget {
  const NavigateBar({super.key});

  @override
  State<NavigateBar> createState() => _NavigateBarState();
}

// 네브 바 버튼 구현하는 클래스
class NavBarButton extends StatelessWidget {
  final String text;
  final String icon;
  final String goalScreen;

  const NavBarButton({
    super.key,
    required this.text,
    required this.icon,
    required this.goalScreen,
  });

  // 클릭하면 해당 화면으로 이동
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, goalScreen);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage(icon),
          ),
          Text(text),
        ],
      ),
    );
  }
}

// 네비게이션 바 구현
class _NavigateBarState extends State<NavigateBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(value),
      color: Colors.green,
      height: 70,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarButton(
            text: '받은 택배함',
            icon: 'assets/icons/box_icon.png',
            goalScreen: '/package',
          ),
          NavBarButton(
            text: '내 양파들',
            icon: 'assets/icons/onion_icon.png',
            goalScreen: '/',
          ),
          NavBarButton(
            text: '내 양파밭',
            icon: 'assets/icons/sprout_icon.png',
            goalScreen: '/field',
          ),
          NavBarButton(
            text: '마이페이지',
            icon: 'assets/icons/mypage_icon.png',
            goalScreen: '/mypage',
          ),
        ],
      ),
    );
  }
}
