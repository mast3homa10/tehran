import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../frontend/pages/exchange/controllers/exchange_page_controller.dart';
import '../../../frontend/pages/final_steps/final_steps_page_controller.dart';
import 'steps/step1.dart';
import 'steps/step2.dart';
import 'steps/step3.dart';

class FinalStepsPage extends StatefulWidget {
  const FinalStepsPage({Key? key}) : super(key: key);

  @override
  State<FinalStepsPage> createState() => _FinalStepsPageState();
}

class _FinalStepsPageState extends State<FinalStepsPage> {
  final finalController = Get.put(FinalStepsController());
  final exchangeController = Get.put(ExchangePageController());

  List<Widget> steps = [
    Step1(),
    Step2(),
    Step3(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppbar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Theme.of(context).appBarTheme.backgroundColor),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: Get.width * 0.1, right: Get.width * 0.1),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 40, maxWidth: Get.width),
                            child: Obx(
                              () => ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: finalController.stepsLabel.length,
                                itemBuilder: (context, index) => SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: finalController
                                                    .isStepActive.value
                                                ? Colors.green
                                                : Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Text(
                                            finalController.stepsLabel[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                        ),
                                      ),
                                      if (index <
                                          finalController.steps.length - 1)
                                        SizedBox(
                                          width: Get.width * 0.2,
                                          child: Divider(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            thickness: 10,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              IndexedStack(
                children: steps,
                index: 0,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration:
            BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'آی دی تراکنش: ',
                style: Theme.of(context).textTheme.headline4,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                FlutterClipboard.copy(
                                        finalController.transaction.value.id!)
                                    .then((value) => log('copied'));
                                Get.snackbar("توجه!", "کپی شد");
                              }),
                        ),
                        Expanded(
                          child: Text(
                            '${finalController.transaction.value.id}',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
