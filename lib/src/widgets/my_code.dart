import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrio/src/app.dart';
import 'package:qrio/src/qr_image_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/qr_code_preview.dart';

class MyCode extends ConsumerWidget {
  const MyCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    QrImageConfig qrImageConfig = ref.watch(qrImageConfigProvider);

    // create onrefresh function to refresh qr code preview
    void onRefresh() async {
      final prefs = await SharedPreferences.getInstance();
      final _vcard = prefs.getString('vcard').toString();
      ref.read(qrImageConfigProvider.notifier).editData(data: _vcard);
    }

    return RefreshIndicator(
      // create widget swipe to refresh
      onRefresh: () async {
        onRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const SizedBox(height: 20),
            QrCodePreview(),
            const SizedBox(height: 20),
            const Text(
              'Swipe down to refresh',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
