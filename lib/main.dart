// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:m_expense/m_expense/list_trip.dart';

import 'm_expense/add_trip.dart';
import 'm_expense/route_names.dart';

void main() {
  runApp(M_Expense());
}

//Widget
class M_Expense extends StatelessWidget {
  const M_Expense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.ListTrip: (context) => const ListTrip(),
        RouteNames.AddTrip: (context) => AddTrip(),
      },
      initialRoute: RouteNames.ListTrip,
    );
  }
}
