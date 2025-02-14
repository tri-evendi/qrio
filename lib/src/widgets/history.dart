import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrio/src/constants.dart';
import 'package:qrio/src/widgets/bottom_snack_bar.dart';
import 'package:qrio/src/widgets/data_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils.dart';

final FutureProvider futureProvider = FutureProvider<dynamic>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> historyList = prefs.getStringList('qrio_history') ?? [];
  return historyList;
});

class History extends ConsumerWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future launchURL(String url, {String? secondUrl}) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else if (secondUrl != null &&
          await canLaunchUrl(Uri.parse(secondUrl))) {
        await launchUrl(
          Uri.parse(secondUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          BottomSnackBar(
            context,
            'I cant open the app',
            icon: Icons.error_outline_rounded,
            background: Theme.of(context).colorScheme.error,
            foreground: Theme.of(context).colorScheme.onError,
          ),
        );
      }
    }

    final _ = ref.refresh(futureProvider);
    final asyncValue = ref.watch(futureProvider);
    return asyncValue.when(
      error: (err, _) => Text(err.toString()), //エラー時
      loading: () => const CircularProgressIndicator(), //読み込み時
      data: (historyList) {
        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 28,
                    ),
                    Text(
                      'History',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Text(
                      '${List.from(historyList).length} items',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: List.from(historyList).isEmpty
                          ? null
                          : () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  icon:
                                      const Icon(Icons.delete_outline_rounded),
                                  title: const Text('Delete'),
                                  content: Text(
                                    'Delete all history?',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            {Navigator.pop(context)},
                                        onLongPress: null,
                                        child: const Text('Cancel')),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        deleteHistory();
                                      },
                                      onLongPress: null,
                                      child: const Text('Delete all'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      icon: const Icon(Icons.delete_outline_rounded),
                      disabledColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.3),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            if (List.from(historyList).isEmpty)
              Column(
                children: [
                  Icon(
                    Icons.update_disabled_rounded,
                    size: 120,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No read/create history',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            for (var e in List.from(historyList.reversed))
              InkWell(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(e))) {
                    launchURL(e);
                  } else {
                    Clipboard.setData(
                      ClipboardData(text: e),
                    ).then((value) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        BottomSnackBar(
                          context,
                          'Copied to clipboard',
                          icon: Icons.library_add_check_rounded,
                        ),
                      );
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 28,
                    ),
                    Expanded(
                      child: Text(
                        '$e',
                        style: TextStyle(
                          fontSize: 16,
                          color: linkFormat.hasMatch(e.toString())
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onBackground,
                          decoration: linkFormat.hasMatch(e.toString())
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Share.share(
                              e,
                              subject: 'QR I/O history sharing',
                            );
                          },
                          icon: const Icon(Icons.share_rounded),
                          padding: const EdgeInsets.all(16.0),
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return DataBottomSheet(data: e, ref: ref);
                              },
                              backgroundColor: Colors.transparent,
                            );
                          },
                          icon: const Icon(Icons.more_vert_rounded),
                          padding: const EdgeInsets.all(16.0),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 28,
            ),
          ],
        );
      }, //データ受け取り時
    );
  }
}
