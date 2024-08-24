import 'package:ip_tv_app/pages/tvchannels.dart';
import 'package:ip_tv_app/pages/tvhome.dart';
import 'package:ip_tv_app/pages/tvrentstore.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../pages/tvchannels.dart';
import '../pages/tvhome.dart';
import '../pages/tvrentstore.dart';
import '../utils/constant.dart';
import '../utils/utils.dart';

class MyPageBuilder extends StatelessWidget {
  const MyPageBuilder({
    super.key,
    required this.controller,
  });

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _replaceByIndex(controller.selectedIndex);
      },
    );
  }

  Widget _replaceByIndex(int index) {
    switch (index) {
      case 6:
        return TVChannels(controller: controller);
      case 7:
        return TVRentStore(controller: controller);
      case 8:
        // return const ActiveTV();
        return Container();
      default:
        return TVHome(pageName: '', controller: controller);
    }
  }

  openDetailPage(BuildContext context) {
    debugPrint(
        "openDetailPage videoId ===> ${Constant.detailIDList['videoId']}");
    debugPrint(
        "openDetailPage upcomingType => ${Constant.detailIDList['upcomingType']}");
    debugPrint(
        "openDetailPage videoType => ${Constant.detailIDList['videoType']}");
    debugPrint(
        "openDetailPage typeId ====> ${Constant.detailIDList['typeId']}");
    int videoId, upcomingType, videoType, typeId;
    videoId = Constant.detailIDList['videoId'] ?? 0;
    upcomingType = Constant.detailIDList['upcomingType'] ?? 0;
    videoType = Constant.detailIDList['videoType'] ?? 0;
    typeId = Constant.detailIDList['typeId'] ?? 0;

    if (!(context.mounted)) return;
    Utils.openDetails(
      context: context,
      videoId: videoId,
      upcomingType: upcomingType,
      videoType: videoType,
      typeId: typeId,
    );
  }
}

String getTitleByIndex(int index) {
  switch (index) {
    case 6:
      return 'Channel';
    case 7:
      return 'Rent';
    case 8:
      return 'TVLogin';
    case 9:
      return 'DetailPage';
    default:
      return 'Home';
  }
}
