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

  bool _force = false;
  String _pendingVersion = '';
  String _pendingUrl = '';

  @override
  void onReady() {
    super.onReady();
    checkForUpdate();
  }

  bool _isSafeApkUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }

  void checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http
          .get(Uri.parse('$baseUrl/api/app-version'))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body)['data'];
      final latestVersion = data['version'] as String;
      final apkUrl = (data['apk_url'] ?? '') as String;

      if (!isNewerVersion(currentVersion, latestVersion)) return;

      if (!_isSafeApkUrl(apkUrl)) {
        debugPrint('Update dibatalkan, apk_url harus https ($apkUrl)');
        return;
      }

      _force = data['force_update'] == true;
      _pendingVersion = latestVersion;
      _pendingUrl = apkUrl;
      _showUpdateDialog();
    } catch (e) {
      debugPrint('Update check error: $e');
    }
  }

  void _showUpdateDialog() {
    Get.dialog(
      PopScope(
        canPop: !_force,
        child: AlertDialog(
          title: const Text('Pembaruan Tersedia'),
          content: Text(
            _force
                ? 'Versi $_pendingVersion wajib dipasang untuk melanjutkan.'
                : 'Versi $_pendingVersion sudah rilis. Perbarui Sekarang?',
          ),
          actions: [
            if (!_force)
              TextButton(
                onPressed: _closeDialogSafely,
                child: const Text('Nanti'),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                _closeDialogSafely();
                _showDownloadProgressDialog();
                _startDownloadAndInstall(_pendingUrl);
              },
              child: const Text(
                'Perbarui',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: !_force,
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
    if (_force) _showUpdateDialog();
  }
}
