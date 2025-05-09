// lib/widgets/event_details/budget/expense_carousel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meetup/widgets/expenses/expense_readonly_card.dart';
import '../../../models/expense_model.dart';

class ExpenseCarousel extends StatefulWidget {
  final List<ExpenseModel> expenses;
  const ExpenseCarousel({super.key, required this.expenses});

  @override
  State<ExpenseCarousel> createState() => _ExpenseCarouselState();
}

class _ExpenseCarouselState extends State<ExpenseCarousel> {
  late final PageController _ctrl;
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: 1);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_page + 1) % widget.expenses.length;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // alto de la card + márgenes
      child: PageView.builder(
        controller: _ctrl,
        onPageChanged: (i) => _page = i,
        itemCount: widget.expenses.length,
        itemBuilder: (_, i) => ExpenseReadOnlyCard(expense: widget.expenses[i]),
      ),
    );
  }
}
