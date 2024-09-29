// ignore: unused_import
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:bottom_bar_matu/bottom_bar_matu.dart';

import 'camera_page.dart';
import 'dashboard_home.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBarBubble(
        color: Colors.blue,
        backgroundColor: Colors.black,
        bubbleSize: 30.0,
        items: [
          BottomBarItem(
            iconData: Icons.home,
            // label: 'Home',
          ),
          BottomBarItem(
            iconData: Icons.photo_library_outlined,
            // label: 'Calendar',
          ),
          BottomBarItem(
            iconData: Icons.camera_alt_rounded,
            // label: 'Chat',
          ),
          BottomBarItem(
            iconData: Icons.notifications,
            // label: 'Notification',
          ),
          BottomBarItem(
            iconData: Icons.person,
            // label: 'Setting',
          ),
        ],
        onSelect: (index) {
          _controller.jumpToPage(index);
        },
      ),
      body: PageView(
        controller: _controller,
        children: const <Widget>[
          Center(
            child: HomeDashboard(),
          ),
          Center(
            child: CamCompanyStyleCameraUI(),
          ),
          Center(
            child: Text('Third Page'),
          ),
          Center(
            child: Text('Four Page'),
          ),
          Center(
            child: Text('Five Page'),
          ),
        ],
      ),
    );
  }
}
