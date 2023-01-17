import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ErrorConnectedNetwork extends StatelessWidget {
  final Function onPressed;
  const ErrorConnectedNetwork({Key? key, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 70,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'error_connect_to_netwotk'.tr,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
              padding: const EdgeInsets.all(20),
              icon: const Icon(
                Icons.refresh,
                size: 30,
              ),
              onPressed: onPressed as Function()),
        ],
      ),
    );
  }
}
