import 'package:flutter/material.dart';

import '../../widgets/account_info/gray_container_list_tile_widget.dart';

class MoreOption extends StatefulWidget {
  MoreOption({super.key});

  @override
  State<MoreOption> createState() => _MoreOptionState();
}

class _MoreOptionState extends State<MoreOption> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GrayContainerListTileWidget(onTap: () {}, label: 'About Instructor'),
        SizedBox(height: 20),
        GrayContainerListTileWidget(onTap: () {}, label: 'Course Resources'),
        SizedBox(height: 20),
        GrayContainerListTileWidget(onTap: () {}, label: 'Share this course'),
      ],
    );
  }
}
