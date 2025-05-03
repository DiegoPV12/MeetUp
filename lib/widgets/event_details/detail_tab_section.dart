import 'package:flutter/material.dart';

class DetailTabSection extends StatelessWidget {
  final List<Widget> views;

  const DetailTabSection({super.key, required this.views});

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: views);
  }
}
