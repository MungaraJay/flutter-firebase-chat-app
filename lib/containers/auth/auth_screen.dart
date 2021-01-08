import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/containers/auth/login_page.dart';
import 'package:flutter_fire_chat/containers/auth/signup_page.dart';

class AuthScreen extends StatelessWidget {
  PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  animateToPage(index) {
    _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return LoginPage(animateToPage);
            } else {
              return SignupPage(animateToPage);
            }
          },
        ),
      ),
    );
  }
}
