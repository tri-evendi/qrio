import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';
import '../constants.dart';
import '../qr_image_config.dart';
import '../utils.dart';
import 'config_item.dart';
import 'icon_box.dart';
import 'select_qr_config_dialog.dart';

class ConfigItems extends ConsumerWidget {
  const ConfigItems({super.key});

  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _phoneController = TextEditingController();
  static final TextEditingController _linkController = TextEditingController();

  static Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static void updateTextFieldValue() async {
    final prefs = await SharedPreferences.getInstance();
    final _vcard = prefs.getString('vcard').toString();
    _nameController.text = prefs.getString('name') ?? '';
    _nameController.selection =
        TextSelection.collapsed(offset: prefs.getString('name')?.length ?? 0);
    _emailController.text = prefs.getString('email') ?? '';
    _emailController.selection =
        TextSelection.collapsed(offset: prefs.getString('email')?.length ?? 0);
    _phoneController.text = prefs.getString('phone') ?? '';
    _phoneController.selection =
        TextSelection.collapsed(offset: prefs.getString('phone')?.length ?? 0);
    _linkController.text = prefs.getString('link') ?? '';
    _linkController.selection =
        TextSelection.collapsed(offset: prefs.getString('link')?.length ?? 0);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    QrImageConfig qrImageConfig = ref.watch(qrImageConfigProvider);
    Map<String, dynamic> data = {
      'name': '',
      'email': '',
      'phone': '',
      'link': '',
    };

    void collectData() {
      Map<String, dynamic> dataCollected = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'link': _linkController.text,
      };
      // create vcard with data name, email, phone, link
      var vcard = 'BEGIN:VCARD\n';
      vcard += 'VERSION:3.0\n';
      vcard += 'N:${dataCollected['name']}\n';
      vcard += 'FN:${dataCollected['name']}\n';
      vcard +=
          'EMAIL;TYPE=INTERNET;TYPE=WORK;TYPE=pref:${dataCollected['email']}\n';
      vcard += 'TEL;TYPE=CELL;TYPE=pref:${dataCollected['phone']}\n';
      vcard += 'URL:${dataCollected['link']}\n';
      vcard += 'END:VCARD';

      saveData('vcard', vcard);
      ref.read(qrImageConfigProvider.notifier).editData(data: vcard);
    }

    return Column(
      children: <Widget>[
        ...[
          ...data.keys.map(
            (key) => Row(
              children: [
                IconBox(
                  icon: key == 'name'
                      ? Icons.person_rounded
                      : key == 'email'
                          ? Icons.email_rounded
                          : key == 'phone'
                              ? Icons.phone_rounded
                              : Icons.link_rounded,
                ),
                Flexible(
                    child: TextField(
                  decoration: InputDecoration(
                    hintText: key[0].toUpperCase() + key.substring(1),
                    border: InputBorder.none,
                  ),
                  // using conroller to update the text field value
                  controller: key == 'name'
                      ? _nameController
                      : key == 'email'
                          ? _emailController
                          : key == 'phone'
                              ? _phoneController
                              : _linkController,
                  onChanged: (value) {
                    collectData();
                    saveData(key, value);
                  },
                )),
              ],
            ),
          ),
          // create a divider
          const Divider(
            color: Colors.transparent,
            height: 10,
          ),
          ConfigItem(
            title: selectQrSeedColorOptionGroup.title,
            label: selectQrSeedColorOptionGroup
                .getLabelFromValue(qrImageConfig.qrSeedColor),
            icon: selectQrSeedColorOptionGroup.icon!,
            onTapListener: openDialogFactory(SelectQrConfigDialog<Color>(
              title: selectQrSeedColorOptionGroup.title,
              options: selectQrSeedColorOptionGroup.options,
              editConfigFunc: (Color? value) {
                ref
                    .read(qrImageConfigProvider.notifier)
                    .editQrSeedColor(qrSeedColor: value!);
              },
              groupValue: qrImageConfig.qrSeedColor,
            )),
          ),
          ConfigItem(
            title: 'Invert Color',
            icon: Icons.invert_colors_rounded,
            onTapListener: (context) =>
                ref.read(qrImageConfigProvider.notifier).toggleIsReversed(),
            switchValue: qrImageConfig.isReversed,
            switchOnChangeHandler: (value) {
              ref.read(qrImageConfigProvider.notifier).toggleIsReversed();
            },
          ),
          ConfigItem(
            title: selectQrEyeShapeOptionGroup.title,
            label: selectQrEyeShapeOptionGroup
                .getLabelFromValue(qrImageConfig.eyeShape),
            icon: selectQrEyeShapeOptionGroup.icon!,
            onTapListener: openDialogFactory(SelectQrConfigDialog<QrEyeShape>(
              title: selectQrEyeShapeOptionGroup.title,
              options: selectQrEyeShapeOptionGroup.options,
              editConfigFunc: (QrEyeShape? value) {
                ref
                    .read(qrImageConfigProvider.notifier)
                    .editEyeShape(eyeShape: value!);
              },
              groupValue: qrImageConfig.eyeShape,
            )),
          ),
          ConfigItem(
            title: selectQrDataModuleShapeOptionGroup.title,
            label: selectQrDataModuleShapeOptionGroup
                .getLabelFromValue(qrImageConfig.dataModuleShape),
            icon: selectQrDataModuleShapeOptionGroup.icon!,
            onTapListener:
                openDialogFactory(SelectQrConfigDialog<QrDataModuleShape>(
              title: selectQrDataModuleShapeOptionGroup.title,
              options: selectQrDataModuleShapeOptionGroup.options,
              editConfigFunc: (QrDataModuleShape? value) {
                ref
                    .read(qrImageConfigProvider.notifier)
                    .editDataModuleShape(dataModuleShape: value!);
              },
              groupValue: qrImageConfig.dataModuleShape,
            )),
          ),
          ConfigItem(
            title: selectQrErrorCorrectLevelOptionGroup.title,
            label: selectQrErrorCorrectLevelOptionGroup
                .getLabelFromValue(qrImageConfig.errorCorrectLevel),
            icon: selectQrErrorCorrectLevelOptionGroup.icon!,
            onTapListener: openDialogFactory(SelectQrConfigDialog<int>(
              title: selectQrErrorCorrectLevelOptionGroup.title,
              options: selectQrErrorCorrectLevelOptionGroup.options,
              editConfigFunc: (int? value) {
                ref
                    .read(qrImageConfigProvider.notifier)
                    .editErrorCorrectLevel(errorCorrectLevel: value!);
              },
              groupValue: qrImageConfig.errorCorrectLevel,
            )),
          ),
        ].expand(
          (widget) => [
            widget,
            Divider(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            )
          ],
        )
      ],
    );
  }
}
