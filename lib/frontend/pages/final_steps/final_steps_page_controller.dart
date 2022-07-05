import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../backend/models/create_transaction_model.dart';
import '../../../frontend/pages/exchange/controllers/timer_controller.dart';

enum Step { first, second, third }

class FinalStepsController extends GetxController {
  var currentstep = Step.first.obs;
  var isStepActive = false.obs;

  var timerController = TimerController().obs;
  var transaction = CreateTransactionModel().obs;
  setTransactioin(CreateTransactionModel item) => transaction = item.obs;

  @override
  void onClose() {
    timerController.value.stopTimer();
    super.onClose();
  }

  var steps = [
    const Text('test1'),
    const Text('test12'),
    const Text('test123'),
  ].obs;
  var stepsLabel = [
    '3',
    '2',
    '1',
  ].obs;
}
