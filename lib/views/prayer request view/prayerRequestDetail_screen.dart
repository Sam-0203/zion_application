import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/viewmodels/prayer_request_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:get/get.dart';

class PrayerRequestDetailScreen extends StatefulWidget {
  const PrayerRequestDetailScreen({super.key, required this.prayerId});

  final int prayerId;

  @override
  State<PrayerRequestDetailScreen> createState() =>
      _PrayerRequestDetailScreenState();
}

class _PrayerRequestDetailScreenState extends State<PrayerRequestDetailScreen> {
  late PrayerRequestAndWordOfGodViewModel controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<PrayerRequestAndWordOfGodViewModel>();

    debugPrint('Detail Screen Prayer ID: ${widget.prayerId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPrayerDetails(widget.prayerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrayerRequestAndWordOfGodViewModel>(
      builder: (controller) {
        if (controller.isPrayerDetailsLoading ||
            !controller.hasLoadedPrayerDetails) {
          return AppScaffold(
            appBar: const UniversalAppBar(
              title: CustomStrings.prayerRequestTitle,
            ),
            body: const PrayerDetailSkeletonLoader(),
          );
        }

        if (controller.prayerDetailsError != null) {
          return AppScaffold(
            appBar: const UniversalAppBar(
              title: CustomStrings.prayerRequestTitle,
            ),
            body: UniversalErrorLoader(
              loader: const PrayerDetailSkeletonLoader(),
            ),
          );
        }

        final details = controller.prayerDetails;

        if (details == null) {
          return AppScaffold(
            appBar: const UniversalAppBar(
              title: CustomStrings.prayerRequestTitle,
            ),
            body: const UniversalNoDataMessage(),
          );
        }

        final data = details.data;

        return AppScaffold(
          appBar: UniversalAppBar(
            title: CustomStrings.prayerRequestTitle,
            actions: data.isMe
                ? [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          debugPrint('ID: ${widget.prayerId}');
                        },
                        child: AppIcons.deleteIcon(color: Colors.red),
                      ),
                    ),
                  ]
                : [],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(data.prayer, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 16),
                Text(CustomStrings.prayerViewsCount(data.viewCount)),
              ],
            ),
          ),
        );
      },
    );
  }
}
