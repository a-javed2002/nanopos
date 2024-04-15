import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Home/order.dart';
import 'package:nanopos/views/Print/testprint.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrintController extends GetxController {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  RxList<BluetoothDevice> _devices = <BluetoothDevice>[].obs;
  BluetoothDevice? _device;
  var connected = false.obs;
  TestPrint testPrint = TestPrint();

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          connected.value = true;
          print("bluetooth device state: connected");
          break;
        case BlueThermalPrinter.DISCONNECTED:
          connected.value = false;
          print("bluetooth device state: disconnected");
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          connected.value = false;
          print("bluetooth device state: disconnect requested");
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          connected.value = false;
          print("bluetooth device state: bluetooth turning off");
          break;
        case BlueThermalPrinter.STATE_OFF:
          connected.value = false;
          print("bluetooth device state: bluetooth off");
          break;
        case BlueThermalPrinter.STATE_ON:
          connected.value = false;
          print("bluetooth device state: bluetooth on");
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          connected.value = false;
          print("bluetooth device state: bluetooth turning on");
          break;
        case BlueThermalPrinter.ERROR:
          connected.value = false;
          print("bluetooth device state: error");
          break;
        default:
          print(state);
          break;
      }
    });

    // if (!mounted) return;
    // _devices.value = devices;

    // Check if the controller is initialized before updating values
    if (connected != null &&
        _devices != null &&
        !(connected.value == null) &&
        !(_devices.value == null)) {
      _devices.value = devices;

      if (isConnected == true) {
        connected.value = true;
      }
    } else {
      return;
    }
  }

  void printDialog({required Order order,required BuildContext context,required loginUser user,String billStatus = "Un Paid"}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Print"),
            content: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    const Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (BluetoothDevice? value) => _device = value,
                        value: _device,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: const Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              connected.value ? Colors.red : Colors.green),
                      onPressed: () {
                        connected.value
                            ? disconnect(context)
                            : connect(context);
                      },
                      child: Text(
                        connected.value ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    onPressed: () {
                          testPrint.printBill(
                              order: order, status: billStatus, user: user);
                    },
                    child: const Text('Print Slip',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showToast({required BuildContext context, required String message}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Adjust the duration as needed
      behavior: SnackBarBehavior
          .floating, // Ensure SnackBar is displayed above other content
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void connect(BuildContext context) {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            connected.value = false;
          });
          connected.value = true;
          show('Connected.', context: context);
        }
      });
    } else {
      show('No device selected.', context: context);
    }
  }

  void disconnect(BuildContext context) {
    bluetooth.disconnect();
    connected.value = false;
    show('Disconnected.', context: context);
  }

  Future show(String message,
      {Duration duration = const Duration(seconds: 3),
      required BuildContext context}) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
      ),
    );
  }
}
