package com.example.nanopos

import android.R
import android.os.RemoteException
import com.topwise.cloudpos.aidl.printer.AidlPrinter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Bundle
import android.os.IBinder
import android.util.Log

import com.topwise.cloudpos.aidl.AidlDeviceService
import com.topwise.cloudpos.aidl.buzzer.AidlBuzzer
import com.topwise.cloudpos.aidl.camera.AidlCameraScanCode
import com.topwise.cloudpos.aidl.cpucard.AidlCPUCard
import com.topwise.cloudpos.aidl.decoder.AidlDecoderManager
import com.topwise.cloudpos.aidl.emv.level2.AidlAmex
import com.topwise.cloudpos.aidl.emv.level2.AidlEmvL2
import com.topwise.cloudpos.aidl.emv.level2.AidlEntry
import com.topwise.cloudpos.aidl.emv.level2.AidlPaypass
import com.topwise.cloudpos.aidl.emv.level2.AidlPaywave
import com.topwise.cloudpos.aidl.emv.level2.AidlPure
import com.topwise.cloudpos.aidl.emv.level2.AidlQpboc
import com.topwise.cloudpos.aidl.iccard.AidlICCard
import com.topwise.cloudpos.aidl.led.AidlLed
import com.topwise.cloudpos.aidl.magcard.AidlMagCard
import com.topwise.cloudpos.aidl.pedestal.AidlPedestal
import com.topwise.cloudpos.aidl.pinpad.AidlPinpad
import com.topwise.cloudpos.aidl.psam.AidlPsam
import com.topwise.cloudpos.aidl.rfcard.AidlRFCard
import com.topwise.cloudpos.aidl.serialport.AidlSerialport
import com.topwise.cloudpos.aidl.shellmonitor.AidlShellMonitor
import com.topwise.cloudpos.aidl.system.AidlSystem


class MainActivity: FlutterActivity() {
    private val CHANNEL = "TopSdkMethods"
    private var printerDev: AidlPrinter? = null
    private val TAG = "PrintDevActivity"
    private val biasRunning = false
    private val printRunning = false
    private val BUFF_LEN = 48 * 2 * 5

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        printerDev = DeviceServiceManager.getInstance().getPrintManager()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "PrintSlip") {
                    //val returnValue = PrintSlip()
                    //result.success(returnValue)

                    printBias()
                    result.success("Printing bias started")
                }
                else if (call.method == "ScanCard") {
                    val returnValue = ScanCard()
                    result.success(returnValue)
                }
                else {
                    result.notImplemented()
                }
            }
    }

    private fun PrintSlip(): String {
        // Implement your native function logic here
        return "Print Slip"
    }

    private fun ScanCard(): String {
        // Implement your native function logic here
        return "Scan Card"
    }
    // TopSdk Methods
    private fun printBias() {
        Thread {
            try {
                val printBuf: ByteArray = getBitmpBuff()
                var ret = 0
                while (biasRunning) {
                    ret = printerDev!!.printBuf(printBuf)
                    if (ret != 0) {
                        break
                    }
                }
                printerDev!!.close()
                if (ret == 0) {
                    //showMessage(resources.getString(R.string.print_success))
                } else {
                    //showMessage(resources.getString(R.string.print_error_code) + ret)
                }
            } catch (e: RemoteException) {
                e.printStackTrace()
            }
        }.start()
    }
    fun getBitmpBuff(): ByteArray {
        val time = 1
        val buffer = ByteArray(48 * 8 * time)
        var data: Byte = 0x80.toByte()
        for (j in 0 until time) {
            var i = 0
            while (i < 8) {
                val temp = fillAndGetBuf((data.toInt() and 0xff shr i).toByte())
                System.arraycopy(temp, 0, buffer, 384 * j + i * 48, 48)
                //LogUtil.d(TAG, "temp len===  " + HexUtil.bcd2str(temp))
                i++
            }
        }
        return buffer
    }

    private fun fillAndGetBuf(data: Byte): ByteArray? {
        val buffer = ByteArray(48)
        for (i in 0..47) {
            buffer[i] = data
        }
        return buffer
    }
}

class DeviceServiceManager private constructor() {
    private val TAG = "DeviceServiceManager"

    private val DEVICE_SERVICE_PACKAGE_NAME = "com.android.topwise.topusdkservice"
    private val DEVICE_SERVICE_CLASS_NAME = "com.android.topwise.topusdkservice.service.DeviceService"
    private val ACTION_DEVICE_SERVICE = "topwise_cloudpos_device_service"

    private var mContext: Context? = null
    private var mDeviceService: AidlDeviceService? = null
    private var isBind = false

    companion object {
        private var instance: DeviceServiceManager? = null

        @JvmStatic
        fun getInstance(): DeviceServiceManager {
            //Log.d(TAG, "getInstance()")
            return instance ?: synchronized(this) {
                instance ?: DeviceServiceManager().also { instance = it }
            }
        }
    }

    fun isBind(): Boolean {
        return isBind
    }

//    fun bindDeviceService(context: Context): Boolean {
//        Log.i(TAG, "")
//
//        mContext = context
//        val intent = Intent().apply {
//            action = ACTION_DEVICE_SERVICE
//            setClassName(DEVICE_SERVICE_PACKAGE_NAME, DEVICE_SERVICE_CLASS_NAME)
//        }
//
//        return try {
//            val bindResult = mContext.bindService(intent, mConnection, Context.BIND_AUTO_CREATE)
//            Log.i(TAG, "bindResult = $bindResult")
//            bindResult
//        } catch (e: Exception) {
//            e.printStackTrace()
//            false
//        }
//    }

//    fun unBindDeviceService() {
//        Log.i(TAG, "unBindDeviceService")
//        try {
//            mContext.unbindService(mConnection)
//        } catch (e: Exception) {
//            Log.i(TAG, "unbind DeviceService service failed : $e")
//        }
//    }

    private val mConnection = object : ServiceConnection {
        override fun onServiceConnected(componentName: ComponentName, service: IBinder) {
            mDeviceService = AidlDeviceService.Stub.asInterface(service)
            Log.d(TAG, "gz mDeviceService$mDeviceService")
            isBind = true
            Log.i(TAG, "onServiceConnected  :  $mDeviceService")
        }

        override fun onServiceDisconnected(componentName: ComponentName) {
            Log.i(TAG, "onServiceDisconnected  :  $mDeviceService")
            mDeviceService = null
            isBind = false
        }
    }

    fun getSystemManager(): AidlSystem? {
        return try {
            if (mDeviceService != null) {
                AidlSystem.Stub.asInterface(mDeviceService?.systemService)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getBuzzer(): AidlBuzzer? {
        return try {
            if (mDeviceService != null) {
                AidlBuzzer.Stub.asInterface(mDeviceService?.buzzer)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }
    fun getDecoder(): AidlDecoderManager? {
        return try {
            if (mDeviceService != null) {
                AidlDecoderManager.Stub.asInterface(mDeviceService?.decoder)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getLed(): AidlLed? {
        return try {
            if (mDeviceService != null) {
                AidlLed.Stub.asInterface(mDeviceService?.led)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getPinpadManager(devid: Int): AidlPinpad? {
        return try {
            if (mDeviceService != null) {
                AidlPinpad.Stub.asInterface(mDeviceService?.getPinPad(devid))
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getPrintManager(): AidlPrinter? {
        return try {
            if (mDeviceService != null) {
                AidlPrinter.Stub.asInterface(mDeviceService?.printer)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getICCardReader(): AidlICCard? {
        return try {
            if (mDeviceService != null) {
                AidlICCard.Stub.asInterface(mDeviceService?.insertCardReader)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getRfCardReader(): AidlRFCard? {
        return try {
            if (mDeviceService != null) {
                AidlRFCard.Stub.asInterface(mDeviceService?.rfidReader)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getPsamCardReader(devid: Int): AidlPsam? {
        return try {
            if (mDeviceService != null) {
                AidlPsam.Stub.asInterface(mDeviceService?.getPSAMReader(devid))
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }
    fun getMagCardReader(): AidlMagCard? {
        return try {
            if (mDeviceService != null) {
                AidlMagCard.Stub.asInterface(mDeviceService?.magCardReader)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getCPUCardReader(): AidlCPUCard? {
        return try {
            if (mDeviceService != null) {
                AidlCPUCard.Stub.asInterface(mDeviceService?.cpuCard)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getSerialPort(port: Int): AidlSerialport? {
        return try {
            if (mDeviceService != null) {
                AidlSerialport.Stub.asInterface(mDeviceService?.getSerialPort(port))
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getShellMonitor(): AidlShellMonitor? {
        return try {
            if (mDeviceService != null) {
                AidlShellMonitor.Stub.asInterface(mDeviceService?.shellMonitor)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getPedestal(): AidlPedestal? {
        return try {
            if (mDeviceService != null) {
                AidlPedestal.Stub.asInterface(mDeviceService?.pedestal)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getEmvL2(): AidlEmvL2? {
        return try {
            if (mDeviceService != null) {
                AidlEmvL2.Stub.asInterface(mDeviceService?.l2Emv)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getL2Pure(): AidlPure? {
        return try {
            if (mDeviceService != null) {
                AidlPure.Stub.asInterface(mDeviceService?.l2Pure)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getL2Paypass(): AidlPaypass? {
        return try {
            if (mDeviceService != null) {
                AidlPaypass.Stub.asInterface(mDeviceService?.l2Paypass)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getL2Paywave(): AidlPaywave? {
        return try {
            if (mDeviceService != null) {
                AidlPaywave.Stub.asInterface(mDeviceService?.l2Paywave)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }
    fun getL2Entry(): AidlEntry? {
        return try {
            if (mDeviceService != null) {
                AidlEntry.Stub.asInterface(mDeviceService?.l2Entry)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getL2Amex(): AidlAmex? {
        return try {
            if (mDeviceService != null) {
                AidlAmex.Stub.asInterface(mDeviceService?.l2Amex)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getL2Qpboc(): AidlQpboc? {
        return try {
            if (mDeviceService != null) {
                AidlQpboc.Stub.asInterface(mDeviceService?.l2Qpboc)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun getCameraManager(): AidlCameraScanCode? {
        return try {
            if (mDeviceService != null) {
                AidlCameraScanCode.Stub.asInterface(mDeviceService?.cameraManager)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

    fun expandFunction(param: Bundle?): Bundle? {
        return try {
            if (mDeviceService != null) {
                mDeviceService?.expandFunction(param)
            } else null
        } catch (e: RemoteException) {
            e.printStackTrace()
            null
        }
    }

}
