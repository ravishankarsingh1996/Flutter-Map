import 'package:flutter/material.dart';


class FancyFab extends StatefulWidget {
  final Function(int type) onPressed;
  final String tooltip;
  final IconData icon;


  FancyFab({this.onPressed, this.tooltip, this.icon});


  @override
  _FancyFabState createState() => _FancyFabState(onPressed);
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  Function(int type) onPressed;

  _FancyFabState(this.onPressed);


  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget myLocation() {
    return Container(
      child: FloatingActionButton(
        onPressed: (){
          onPressed(2);
        },
        tooltip: 'MyLocation',
        child: Icon(Icons.my_location),

      ),
    );
  }

  Widget sataliteView() {
    return Container(
      child: FloatingActionButton(
        onPressed: (){
          onPressed(1);
        },
        tooltip: 'SataliteView',
        child: Icon(Icons.satellite),
      ),
    );
  }

  Widget groundLevel() {
    return Container(
      child: FloatingActionButton(
        onPressed: (){
          onPressed(0);
        },
        tooltip: 'GroundLevel',
        child: Icon(Icons.accessibility),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: myLocation(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: sataliteView(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: groundLevel(),
        ),
        toggle(),
      ],
    );
  }
}

typedef ChildCallback = void Function(int type);
