package com.example.super_app

import android.content.pm.ApplicationInfo
import io.flutter.embedding.android.FlutterActivity
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel = "com.example.app/package"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, channel).setMethodCallHandler { call, result ->
            if (call.method == "getInstalledPackages") {
                val packages = getInstalledPackages()

                result.success(packages)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getInstalledPackages(): List<Map<String, Any>> {
        val packageManager: PackageManager = packageManager
        val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)

        return packages.map { appInfo ->
            val appName = packageManager.getApplicationLabel(appInfo).toString()
            val packageName = appInfo.packageName
            val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

            // Cek apakah aplikasi memiliki permission QUERY_ALL_PACKAGES (untuk SDK 30 ke atas)
            val hasQueryAllPackagesPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                packageManager.checkPermission(
                    "android.permission.QUERY_ALL_PACKAGES", packageName
                ) == PackageManager.PERMISSION_GRANTED
            } else {
                false // Untuk SDK di bawah R, kita set false karena permission ini tidak ada
            }

            mapOf(
                "appName" to appName,
                "packageName" to packageName,
                "isSystemApp" to isSystemApp,
                "hasQueryAllPackagesPermission" to hasQueryAllPackagesPermission
            )
        }
    }
}
