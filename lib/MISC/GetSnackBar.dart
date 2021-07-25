
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackBar(String message){
  Get.snackbar('Error', message, backgroundColor: Colors.red[400], colorText: Colors.white);
}