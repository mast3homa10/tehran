import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../frontend/pages/exchange/controllers/exchange_page_controller.dart';
import '../../../frontend/components/custom_timer.dart';
import '../../../frontend/pages/final_steps/final_steps_page_controller.dart';

class FinalStepsPage extends StatefulWidget {
  const FinalStepsPage({Key? key}) : super(key: key);

  @override
  State<FinalStepsPage> createState() => _FinalStepsPageState();
}

class _FinalStepsPageState extends State<FinalStepsPage> {
  final finalController = Get.put(FinalStepsController());
  final exchangeController = Get.put(ExchangePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: kAppbar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                                itemCount: finalController.stepslable.length,
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
                                                    .isActive.value
                                                ? Colors.green
                                                : Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Text(
                                            finalController.stepslable[index],
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
                      Text(
                        'زمان باقی مانده برای ارسال ',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      CustomTimer(
                          maxSecond: 600,
                          controller: finalController.timerController.value),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مقدار واریزی توسط شما: ',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Row(
                            //   children: const [
                            //     Padding(
                            //       padding: EdgeInsets.all(8.0),
                            //       child: Icon(Icons.copy),
                            //     ),
                            //     VerticalDivider(
                            //       width: 10.0,
                            //       thickness: 2.0,
                            //     ),
                            //   ],
                            // ),
                            Text(
                              '${exchangeController.forSellAmount}',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'لطفا مقدار  ${exchangeController.forSellChoice!.symbol!.toUpperCase()}(${exchangeController.forSellChoice!.inNetwork!.toLowerCase()}) مشخص شده را به آدرس زیر واریز نمایید: ',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.copy),
                                ),
                                VerticalDivider(
                                  width: 10.0,
                                  thickness: 2.0,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Text(
                                  '${finalController.transaction.value.payinAddress}',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).appBarTheme.backgroundColor),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'به اشتراک گذاری',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const Icon(Icons.share)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).appBarTheme.backgroundColor),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'مشاهده بارکد QR',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const Icon(Icons.qr_code)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).appBarTheme.backgroundColor),
                child: ExpansionTile(
                    collapsedIconColor: Theme.of(context).iconTheme.color,
                    collapsedBackgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    iconColor: Theme.of(context).iconTheme.color,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'مقدار ${exchangeController.forBuyChoice!.symbol!.toUpperCase()}(${exchangeController.forBuyChoice!.inNetwork!.toUpperCase()}) دریافتی شما :',
                            style: Theme.of(context).textTheme.headline4),
                        Text(
                          '(${exchangeController.forBuyChoice!.inNetwork!.toUpperCase()})  ${exchangeController.forBuyAmount}   ~',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                              ' آدرس کیف پول ${exchangeController.forBuyChoice!.symbol!.toUpperCase()}(${exchangeController.forBuyChoice!.inNetwork!.toUpperCase()}) شما: ',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline4),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Text(
                            exchangeController.textAddressController.text,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.green),
                          ),
                        ),
                      ),
                    ]),
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
                        const Icon(Icons.copy),
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
