import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

class AnimatedRenewButton extends StatefulWidget {
  const AnimatedRenewButton({
    super.key,
  });

  @override
  State<AnimatedRenewButton> createState() => _AnimatedRenewButtonState();
}

class _AnimatedRenewButtonState extends State<AnimatedRenewButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  void _animationChange() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reset();
      _controller.forward();
    } else {
      _controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1), //アニメーションの時間
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {});
    });

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) => child!,
        child: Transform.rotate(
          angle: _rotateAnimation.value,
          child: const Icon(Icons.autorenew),
        ),
      ),
      onPressed: () {
        _animationChange();
        Provider.of<PasswordModel>(
          context,
          listen: false,
        ).update();
      },
    );
  }
}
