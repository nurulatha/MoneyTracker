import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/widget/transaction_list.dart';

class TypeTabBar extends StatelessWidget {
  const TypeTabBar({super.key, required this.category, required this.monthYear});
  final String category;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(
              text: "Income",
            ),
            Tab(
              text: "Expense",
            ),
          ]),
          Expanded(
              child: TabBarView(
            children: [
              TransectionList(
                category: category ,
                monthYear: monthYear,
                type: 'income',
              ),
              TransectionList(
                category: category ,
                monthYear: monthYear,
                type: 'expense',
              ),
            ],
          ))
        ],
      ),
    ));
  }
}
