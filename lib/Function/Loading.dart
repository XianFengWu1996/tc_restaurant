import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

handleStartLoading(){
  EasyLoading.show(
    status: 'Loading..',
    indicator: CircularProgressIndicator(),
    maskType: EasyLoadingMaskType.black,
  );
}

handleEndLoading(){
  EasyLoading.dismiss();
}