import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

// import '../constants.dart';
// import '../utils.dart';
import '../widgets/default_popup_menu.dart';
// import '../widgets/history.dart';
import '../widgets/qrio.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                  ? 'assets/svg/icon_dark.svg'
                  : 'assets/svg/icon_light.svg',
              width: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'TAN Business Card',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          DefaultPopupMenu(),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: const [Qrio()
        ],
      ),
    );
  }
}
