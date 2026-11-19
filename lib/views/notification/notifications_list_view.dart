import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';

class NotificationsListView extends StatefulWidget {
  const NotificationsListView({super.key});

  @override
  State<NotificationsListView> createState() => _NotificationsListViewState();
}

class _NotificationsListViewState extends State<NotificationsListView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Text(
          'Notifications List View',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
