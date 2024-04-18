import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeFunctionScreen extends StatelessWidget {
  const NativeFunctionScreen({Key? key}): super(key: key);
  final MethodChannel _channel = const MethodChannel('TopSdkMethods');

  Future<void> callNativeFunction(String name) async {
    try {
      final String result = await _channel.invokeMethod(name);
      if (kDebugMode) {
        print('Result from native: $result');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Function Screen'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                callNativeFunction('PrintSlip');
              },
              child: const Text('Print Slip'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                callNativeFunction('ScanCard');
              },
              child: const Text('scan Card'),
            ),
          ),
        ],
      ),
    );
  }
}
