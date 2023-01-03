import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'enums/default_popup_menu_items_type.dart';
import 'widgets/select_option.dart';

const Color seedColor = Color(0xFF30A3F0);

const defaultSheetHeight = 0.1;

const List<Map<String, dynamic>> defaultPopupMenuItems = [
  // {
  //   'label': '履歴',
  //   'value': DefaultPopupMenuItemsType.history,
  //   'icon': Icons.history_rounded,
  // },
  {
    'label': 'About this App',
    'value': DefaultPopupMenuItemsType.about,
    'icon': Icons.description_outlined,
  },
  {
    'label': 'Theme Selection',
    'value': DefaultPopupMenuItemsType.selectTheme,
    'icon': Icons.brightness_medium_rounded,
  },
];

final SelectOptionGroup<ThemeMode> selectThemeOptionGroup = SelectOptionGroup(
  title: 'Theme Selection',
  options: [
    SelectOption<ThemeMode>(label: 'Light', value: ThemeMode.light),
    SelectOption<ThemeMode>(label: 'Dark', value: ThemeMode.dark),
    SelectOption<ThemeMode>(label: 'System Default', value: ThemeMode.system),
  ],
);

final SelectOptionGroup<QrEyeShape> selectQrEyeShapeOptionGroup =
    SelectOptionGroup(
  title: 'Cutout symbol shape',
  icon: Icons.all_out_rounded,
  options: [
    SelectOption<QrEyeShape>(label: 'Circle', value: QrEyeShape.circle),
    SelectOption<QrEyeShape>(label: 'Square', value: QrEyeShape.square),
  ],
);

final SelectOptionGroup<QrDataModuleShape> selectQrDataModuleShapeOptionGroup =
    SelectOptionGroup(
  title: 'Shape',
  icon: Icons.apps_rounded,
  options: [
    SelectOption<QrDataModuleShape>(
        label: 'Circle', value: QrDataModuleShape.circle),
    SelectOption<QrDataModuleShape>(
        label: 'Square', value: QrDataModuleShape.square),
  ],
);

final SelectOptionGroup<int> selectQrErrorCorrectLevelOptionGroup =
    SelectOptionGroup(
  title: 'Error correction capability',
  icon: Icons.check_circle_outline_rounded,
  options: [
    SelectOption<int>(label: 'Level H', value: QrErrorCorrectLevel.H),
    SelectOption<int>(label: 'Level L', value: QrErrorCorrectLevel.L),
    SelectOption<int>(label: 'Level M', value: QrErrorCorrectLevel.M),
    SelectOption<int>(label: 'Level Q', value: QrErrorCorrectLevel.Q),
  ],
);

final SelectOptionGroup<Color> selectQrSeedColorOptionGroup = SelectOptionGroup(
  title: 'QR Code Color',
  icon: Icons.palette_outlined,
  options: [
    // SelectOption<Color>(label: 'ホワイト', value: const Color(0xFFFFFFFF)),
    SelectOption<Color>(label: 'Black', value: const Color(0xFF333333)),
    SelectOption<Color>(label: 'Blue', value: Colors.blue),
    SelectOption<Color>(label: 'Pink', value: Colors.pink),
    SelectOption<Color>(label: 'Oarange', value: Colors.orange),
    SelectOption<Color>(label: 'Green', value: Colors.green),
    SelectOption<Color>(label: 'Puprle', value: Colors.purple),
  ],
);

RegExp linkFormat = RegExp(
    r'((https?:\/\/)|(https?:www\.)|(www\.))[a-zA-Z0-9-]{1,256}\.[a-zA-Z0-9]{2,6}(\/[a-zA-Z0-9亜-熙ぁ-んァ-ヶ()@:%_\+.~#?&\/=-]*)?');
