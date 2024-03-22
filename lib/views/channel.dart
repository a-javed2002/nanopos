import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeFunctionScreen extends StatelessWidget {
  final MethodChannel _channel = MethodChannel('TopSdkMethods');

  Future<void> callNativeFunction(String name) async {
    try {
      final String result = await _channel.invokeMethod(name);
      print('Result from native: $result');
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Native Function Screen'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: (){
                callNativeFunction('PrintSlip');
              },
              child: Text('Print Slip'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: (){
                callNativeFunction('ScanCard');
              },
              child: Text('scan Card'),
            ),
          ),
        ],
      ),  
    );
  }
}
