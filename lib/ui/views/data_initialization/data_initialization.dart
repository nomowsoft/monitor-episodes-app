import 'package:flutter/material.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

class DataInitialization extends StatefulWidget {
  const DataInitialization({super.key});

  @override
  State<DataInitialization> createState() => _DataInitializationState();
}

class _DataInitializationState extends State<DataInitialization> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
      ),
    );
  }
}
