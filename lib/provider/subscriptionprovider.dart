import 'dart:developer';
import 'package:flutter/material.dart';

import '../model/subscriptionmodel.dart';
import '../utils/constant.dart';
import '../webservice/apiservices.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionModel subscriptionModel = SubscriptionModel();

  bool loading = false;

  Future<void> getPackages() async {
    debugPrint("getPackages userID :==> ${Constant.userID}");
    loading = true;
    subscriptionModel = await ApiService().subscriptionPackage();
    debugPrint("get_package status :==> ${subscriptionModel.status}");
    debugPrint("get_package message :==> ${subscriptionModel.message}");
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    log("<================ clearSubscriptionProvider ================>");
    subscriptionModel = SubscriptionModel();
  }
}
