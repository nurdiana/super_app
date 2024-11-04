import 'package:flutter/services.dart';

import 'dart:async';

import 'package:flutter/material.dart';

class QueryAllPackage extends StatefulWidget {
  const QueryAllPackage({super.key});

  @override
  State<QueryAllPackage> createState() => _QueryAllPackageState();
}

class _QueryAllPackageState extends State<QueryAllPackage> {
  List<Map<String, String>> packages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query All Package')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: PackageUtils.getInstalledPackages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No installed packages found.'));
          } else {
            final packages = snapshot.data!;
            return ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final app = packages[index];
                final appName = app['appName'] ?? 'Unknown';
                final packageName = app['packageName'] ?? 'Unknown';
                final isSystemApp = app['isSystemApp'] ?? false;
                final hasQueryAllPackagesPermission = app['hasQueryAllPackagesPermission'] ?? false;

                return ListTile(
                  leading: Icon(isSystemApp ? Icons.android : Icons.apps),
                  title: Text(appName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package: $packageName'),
                      if (hasQueryAllPackagesPermission)
                        const Text('Has QUERY_ALL_PACKAGES permission', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  trailing: isSystemApp
                      ? const Text('System App', style: TextStyle(color: Colors.red))
                      : null,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PackageUtils {
  static const platform = MethodChannel('com.example.app/package');

  static Future<List<Map<String, dynamic>>> getInstalledPackages() async {
    try {
      // Memanggil metode native di Kotlin
      final List<dynamic> result = await platform.invokeMethod('getInstalledPackages');

      // Lakukan konversi tipe dengan lebih aman
      return result.map((package) {
        final Map<dynamic, dynamic> packageMap = package as Map<dynamic, dynamic>;
        return packageMap.map((key, value) => MapEntry(key as String, value));
      }).toList();
    } on PlatformException catch (_) {
      return [];
    }
  }
}