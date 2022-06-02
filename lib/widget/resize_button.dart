import 'dart:math';

import 'package:flutter/material.dart';

class ResizeButton extends StatefulWidget {
  final VoidCallback function;
  final Color startColor;
  final Color endColor;
  final String buttonName;
  final String endLabel;
  final Icon icon;
  final double miniSize;
  final double largeSize;
  const ResizeButton(
      {Key? key,
      required this.function,
      this.buttonName = "start",
      this.endLabel = "end",
      this.startColor = Colors.blue,
      this.endColor = Colors.amber,
      this.miniSize = 120,
      this.largeSize = 350,
      this.icon = const Icon(Icons.star_half_rounded)})
      : super(key: key);

  @override
  State<ResizeButton> createState() => _ResizeButtonState();
}

class _ResizeButtonState extends State<ResizeButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _repeatController;
  bool _start = false;
  bool _end = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _repeatController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller.addListener(() {
      setState(() {});
    });
    _repeatController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _repeatController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller.removeListener(() {});
    _repeatController.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: GestureDetector(
      onTap: () {
        widget.function();
        setState(() {
          if (_end) {
            _start = !_start;
            _end = false;
            _start ? _controller.forward() : _controller.reverse();
            _start ? _repeatController.repeat() : _repeatController.stop();
          }
        });
      },
      child: AnimatedOpacity(
        opacity: _start ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 3000),
        child: AnimatedContainer(
          width: _start ? widget.miniSize : widget.largeSize,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _start ? widget.startColor : widget.endColor),
          padding: const EdgeInsets.all(10),
          duration: const Duration(milliseconds: 500),
          child: _start
              ? FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  child: RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0)
                          .animate(_repeatController),
                      child: widget.icon),
                )
              : Center(
                  child: Text(widget.buttonName),
                ),
        ),
        onEnd: () {
          setState(() {
            _start = false;
            _end = true;
          });
        },
      ),
    ));
  }
}
