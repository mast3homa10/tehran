import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../frontend/pages/exchange/controllers/exchange_page_controller.dart';
import '../../frontend/pages/exchange/controllers/timer_controller.dart';
import '../../backend/models/currency_model.dart';
import '../../backend/network_constants.dart';
import '../../constants.dart';
import 'custom_timer.dart';

class CalculateBox extends StatelessWidget {
  CalculateBox({
    Key? key,
    this.boxId = 0,
    this.initialValue,
    this.currency,
    this.isHaveIcon = false,
    this.isIconChange = false,
    this.onPressed,
    this.openIconPressed,
    this.closeIconPressed,
  }) : super(key: key);
  final int boxId;
  final CurrencyModel? currency;
  final String? initialValue;
  final bool isHaveIcon;
  final bool isIconChange;
  final VoidCallback? openIconPressed;
  final VoidCallback? closeIconPressed;
  final VoidCallback? onPressed;

  CalculateBox.second({
    Key? key,
    this.boxId = 1,
    this.initialValue,
    this.currency,
    this.isHaveIcon = true,
    this.isIconChange = false,
    this.onPressed,
    this.openIconPressed,
    this.closeIconPressed,
  }) : super(key: key);
  final timerController = Get.put(TimerController());
  final controller = Get.put(ExchangePageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              Theme.of(context).dividerTheme.color ?? const Color(0xFFEEEEEE),
          style: BorderStyle.solid,
          width: 2.0,
        ),
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
          child: Row(
        children: [
          SizedBox(
            width: Get.width * 0.35,
            child: Column(
              children: [
                // start search page by click the following text button
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(17),
                      ),
                    ),
                    child: TextButton(
                      onPressed: onPressed,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.withOpacity(0.2)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(17)))),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                  width: 0,
                                  color: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor ??
                                      Theme.of(context)
                                          .scaffoldBackgroundColor))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // image part

                          Row(
                            children: [
                              if (currency!.symbol!.length < 8)
                                AspectRatio(
                                  aspectRatio: 11 / 9,
                                  child: SvgPicture.network(
                                    imgUrl + '${currency!.legacyTicker}.svg',
                                    semanticsLabel: 'A shark?!',
                                    placeholderBuilder:
                                        (BuildContext context) => Container(),
                                  ),
                                ),
                              Text(
                                currency!.symbol!.toUpperCase(),
                                style: Theme.of(context).textTheme.headline4,
                                maxLines: 1,
                                textWidthBasis: TextWidthBasis.longestLine,
                              ),
                            ],
                          ),
                          Icon(
                            FontAwesomeIcons.angleDown,
                            color: Theme.of(context).dividerTheme.color,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(17),
                        ),
                        color: kNetworkColorList[
                                currency!.inNetwork!.toLowerCase()] ??
                            Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: Text(
                          currency!.inNetwork!.toUpperCase(),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 2.0,
            thickness: 1.0,
            indent: 3,
            endIndent: 3,
          ),

          Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  key: Key(initialValue!),
                  initialValue: initialValue,
                  toolbarOptions: const ToolbarOptions(
                      copy: false, paste: false, cut: false, selectAll: false),
                  // input amount from user
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).appBarTheme.backgroundColor ??
                                    Colors.greenAccent,
                            width: 0.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).appBarTheme.backgroundColor ??
                                    Colors.red,
                            width: 5.0),
                      ),
                      hintText: 'مقدار را وارد کنید',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                              color: Theme.of(context).dividerTheme.color)),
                  onChanged: (value) {},
                  validator: (value) {
                    if (double.parse(value!) <
                        controller.minimumExchangeAmount.value) {
                      Get.snackbar('توجه! ',
                          " حداقل مقدار ${controller.forSellChoice!.symbol} نباید کمتر از ${controller.maximumExchangeAmount.value} باشد.");
                    }
                  },
                )),
          ),
          // following part is for provide for fixer.
          Expanded(child: buildFixIcon(context)),
        ],
      )),
    );
  }

//
  Widget? buildImage(String? legacyTicker) {
    try {
      return AspectRatio(
        aspectRatio: 0.35,
        child: SvgPicture.network(
          imgUrl + '$legacyTicker.svg',
          semanticsLabel: 'A shark?!',
          placeholderBuilder: (BuildContext context) => Container(),
        ),
      );
    } catch (e) {
      log('$e');
    }
  }

  Widget buildFixIcon(BuildContext context) {
    if (isHaveIcon) {
      return GetBuilder<ExchangePageController>(
        builder: (controller) {
          return isIconChange
              ? Column(
                  children: [
                    if (controller.isIconChange.value && boxId == 1)
                      CustomTimer(
                        maxSecond: 120,
                        controller: timerController,
                      ),
                    const Icon(
                      FontAwesomeIcons.clock,
                      size: 10,
                    ),
                    IconButton(
                      onPressed: closeIconPressed,
                      icon: Icon(
                        CupertinoIcons.lock,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ],
                )
              : IconButton(
                  onPressed: openIconPressed,
                  icon: Icon(
                    CupertinoIcons.lock_open,
                    color: Theme.of(context).dividerTheme.color,
                  ),
                );
        },
      );
    } else {
      return Container();
    }
  }
}
