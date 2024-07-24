import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double? size;

  const CircularProgress({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 25,
      width: size ?? 25, //
      child: const CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
