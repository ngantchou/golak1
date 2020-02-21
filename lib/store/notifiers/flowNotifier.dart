import 'dart:async';

import 'package:flutter/material.dart';

class FlowNotifier with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int $currentPage) {
    _currentPage = $currentPage;
    notifyListeners();
  }

  PageController _controller;
  PageController get controller => _controller;
  set controller(PageController $controller) {
    _controller = $controller;
    notifyListeners();
  }

  init() {
    controller = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  animateToPage(int page) async {
    if (controller == null) init();
    Timer(Duration(milliseconds: 200), () async {
      await controller.animateToPage(
        page,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
      notifyListeners();
    });
  }
}
