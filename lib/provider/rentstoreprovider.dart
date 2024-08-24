import 'dart:developer';
import 'package:flutter/material.dart';

import '../model/rentmodel.dart';
import '../utils/constant.dart';
import '../webservice/apiservices.dart';

class RentStoreProvider extends ChangeNotifier {
  RentModel rentModel = RentModel();

  bool loading = false;

  Future<void> getRentVideoList() async {
    debugPrint("getRentVideoList userID :==> ${Constant.userID}");
    loading = true;
    rentModel = await ApiService().rentVideoList();
    debugPrint("rent_video_list status :==> ${rentModel.status}");
    debugPrint("rent_video_list message :==> ${rentModel.message}");
    loading = false;
    notifyListeners();
  }

  clearRentStoreProvider() {
    log("<================ clearRentStoreProvider ================>");
    rentModel = RentModel();
  }
}
