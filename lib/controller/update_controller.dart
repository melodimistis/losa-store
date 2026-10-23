import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ota_update/ota_update.dart';
import 'package:flutter/material.dart';
import '../const.dart';

class UpdateController extends GetxController {
  var isDownloading = false.obs;
  var downloadProgress = 0.obs;

  void checkForUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      var response = await http.get(Uri.parse('$baseUrl/api/app-version'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        String latestVersion = data['version'];
        String apkUrl = data['apk_url'] ?? '';

        if (_isNewerVersion(currentVersion, latestVersion)) {
          _showUpdateDialog(latestVersion, apkUrl);
        }
      }
    } catch (errorMessage) {
      Get.snackbar('Koneksi Gagal', errorMessage.toString());
    }
  }

  bool _isNewerVersion(String current, String latest) {
    return latest.compareTo(current) > 0;
  }

  void _showUpdateDialog(String newVersion, String apkUrl) {
    Get.defaultDialog(
      title: 'Pembaruan Tersedia Kawan (anjay)',
      middleText: 'Versi $newVersion sudah rilis. Update gas?',
      textConfirm: 'Update',
      textCancel: 'Lah ngapa?',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () {
        Get.back();
        _startOtaUpdate(apkUrl);
      },
    );
  }

  void _startOtaUpdate(String apkUrl) {
    try {
      isDownloading(true);
      OtaUpdate().execute(apkUrl, destinationFilename: 'app-update.apk').listen(
        (OtaEvent event) {
          if (event.status == OtaStatus.DOWNLOADING) {
            downloadProgress.value = int.tryParse(event.value ?? '0') ?? 0;
          } else if (event.status == OtaStatus.INSTALLING) {
            isDownloading(false);
          } else if (event.status == OtaStatus.ALREADY_RUNNING_ERROR ||
              event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
            isDownloading(false);
            Get.snackbar('Error', 'Gagal memproses update: ${event.status}');
          }
        },
      );
    } catch (errorMessage) {
      isDownloading(false);
      Get.snackbar('Koneksi Gagal', errorMessage.toString());
    }
  }
}
