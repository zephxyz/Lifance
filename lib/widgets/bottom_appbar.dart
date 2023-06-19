import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyBottomAppBar extends StatefulWidget {
  final int currentPage;

  const MyBottomAppBar({Key? key, required this.currentPage}) : super(key: key);

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  void handleRedirection(int index) {
    if (index == widget.currentPage) return;
    switch (index) {
      case 0:
        context.go('/profileview');
        break;
      case 1:
        context.go('/');
        break;
      case 2:
        context.go('/historyviewmap');
        break;
      case 3:
        context.go('/historyviewphotos');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
          Tooltip(
            message: "Profile",
            child: IconButton(
              icon: Icon(
                Icons.person,
                color: widget.currentPage == 0 ? const Color(0xff725ac1) : Colors.black,
              ),
              color: Colors.white,
              onPressed: () => handleRedirection(0),
            ),
          ),
          Tooltip(
            message: "Home",
            child: IconButton(
              icon:  Icon(
                Icons.home,
                color: widget.currentPage == 1 ? const Color(0xff725ac1) : Colors.black,
              ),
              color: Colors.white,
              onPressed: () => handleRedirection(1),
            ),
          ),
          const SizedBox(),
          Tooltip(
            message: "History",
            child: IconButton(
                icon: Icon(
                  Icons.timeline,
                  color: widget.currentPage == 2 ? const Color(0xff725ac1) : Colors.black,
                ),
                color: Colors.white,
                onPressed: () => handleRedirection(2)),
          ),
          Tooltip(
            message: "Photos",
            child: IconButton(
                icon: Icon(
                  Icons.photo,
                  color: widget.currentPage == 3 ? const Color(0xff725ac1) : Colors.black,
                ),
                color: Colors.white,
                onPressed: () => handleRedirection(3)),
          )
        ]));
  }
}
