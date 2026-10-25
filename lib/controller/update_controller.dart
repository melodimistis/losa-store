import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../const.dart';
import '../util/version.dart';

class UpdateController extends GetxController {
  var isDownloading = false.obs;
  var downloadProgress = 0.obs;

  @override
  void onReady() {
    super.onReady();
    checkForUpdate();
  }

  void checkForUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      var response = await http.get(Uri.parse('$baseUrl/api/app-version'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        String latestVersion = data['version'];
        String apkUrl = data['apk_url'] ?? '';

        if (isNewerVersion(currentVersion, latestVersion)) {
          _showUpdateDialog(latestVersion, apkUrl);
        }
      }
    } catch (errorMessage) {
      print('Update check error: $errorMessage');
    }
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
        _closeDialogSafely();
        _showDownloadProgressDialog();
        _startDownloadAndInstall(apkUrl);
      },
    );
  }

  void _showDownloadProgressDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Mengunduh Pembaruan...'),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: downloadProgress.value / 100,
                  backgroundColor: Colors.grey[200],
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text('${downloadProgress.value}%'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _startDownloadAndInstall(String apkUrl) async {
    try {
      isDownloading(true);
      downloadProgress.value = 0;

      Directory tempDir = await getTemporaryDirectory();
      String savePath = "${tempDir.path}/app-update.apk";

      Dio dio = Dio();
      await dio.download(
        apkUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = ((received / total) * 100).toInt();
          }
        },
      );

      isDownloading(false);
      _closeDialogSafely();

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done) {
        _handleError('Gagal membuka installer: ${result.message}');
      }
    } catch (errorMessage) {
      _handleError('Gagal mengunduh: $errorMessage');
    }
  }

  void _closeDialogSafely() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void _handleError(String message) {
    isDownloading(false);
    _closeDialogSafely();
    Get.snackbar(
      'Gagal Update',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
