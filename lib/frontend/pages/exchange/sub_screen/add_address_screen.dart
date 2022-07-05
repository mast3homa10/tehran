import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../backend/api/create_transaction.dart';
import '../../../../backend/api/validation_address.dart';
import '../../../../backend/models/validation_address_model.dart';
import '../../../../frontend/pages/exchange/controllers/exchange_page_controller.dart';
import '../../../../frontend/pages/final_steps/final_steps_page_controller.dart';
import '../../../components/address_box.dart';
import '../../final_steps/final_steps_page.dart';
import '../../../components/custom_big_button.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final exchangeController = Get.find<ExchangePageController>();
  bool isPressed = false;
  bool isNextPressd = false;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(
            height: Get.height * 0.37,
            child: Column(
              children: [
                AddressBox(
                  hintText: 'وارد کردن آدرس',
                  textController: exchangeController.textAddressController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                      child: GestureDetector(
                        child: Text(
                          'کیف پول ندارید؟',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        onTap: () {
                          Get.snackbar('توجه!', 'در حال توسعه ...');
                        },
                      ),
                    ),
                  ],
                ),
                if (exchangeController.isSecondBoxShow.value)
                  AddressBox.support(
                    hintText: ' وارد کردن آدرس پشتیبان',
                    textController:
                        exchangeController.textSupportAddressController,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: Get.height < 700 ? Get.height * 0.1 : Get.height * 0.15,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: isPressed
                ? CustomBigButton(
                    label: 'شروع تبادل',
                    onPressed: () async {
                      if (exchangeController
                              .textSupportAddressController.text.isEmpty &&
                          exchangeController.whichButton.value != Button.last &&
                          isNextPressd) {
                        Get.defaultDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: "توجه!",
                          titleStyle: Theme.of(context).textTheme.headline4,
                          content: Text(
                            "آیا از خالی گذاشتن آدرس بازپرداخت مطمئن هستید؟ ",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: const Text(
                                    'بله',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Yekanbakh",
                                        color: Colors.green),
                                  ),
                                  onPressed: () {
                                    exchangeController.goToNext(Button.last);
                                    setState(() {
                                      isPressed = false;
                                    });
                                    Get.back();
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                  child: const Text(
                                    'خیر',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Yekanbakh",
                                        color: Colors.red),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPressed = false;
                                    });
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        setState(() {
                          isPressed = false;
                        });
                        var create = await CreateTransactionApi().create();
                        final finalController = Get.put(FinalStepsController());
                        finalController.setTransactioin(create!);

                        log('here:${create.payinAddress}');
                        Get.to(() => const FinalStepsPage());
                      }
                    },
                  )
                : CustomBigButton(
                    isPressed: isPressed,
                    label: 'بعدی',
                    onPressed: () async {
                      setState(() {
                        isPressed = true;
                      });
                      // kmessage;
                      // controller.changeScreen();
                      if (exchangeController
                          .textAddressController.text.isEmpty) {
                        setState(() {
                          isPressed = false;
                        });
                        Get.snackbar('توجه!',
                            "برای شروع تبادل باید آدرس کیف پول خود را وارد کنید.");
                      } else {
                        ValidationAddressModel? validAddress =
                            await ValidationAddressApi().getValidation(
                                address: exchangeController
                                    .textAddressController.text,
                                currencyNetwork: exchangeController
                                    .forSellChoice!.inNetwork!);
                        if (validAddress!.isValid == 'true') {
                          exchangeController.showSecondBox();
                          setState(() {});

                          if (exchangeController
                                  .textSupportAddressController.text.isEmpty &&
                              exchangeController.whichButton.value !=
                                  Button.last &&
                              isNextPressd) {
                            Get.defaultDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: "توجه!",
                              titleStyle: Theme.of(context).textTheme.headline4,
                              content: Text(
                                "آیا از خالی گذاشتن آدرس بازپرداخت مطمئن هستید؟ ",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: const Text(
                                        'بله',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Yekanbakh",
                                            color: Colors.green),
                                      ),
                                      onPressed: () {
                                        exchangeController
                                            .goToNext(Button.last);
                                        setState(() {
                                          isPressed = false;
                                        });
                                        Get.back();
                                      },
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'خیر',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Yekanbakh",
                                            color: Colors.red),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPressed = false;
                                        });
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            setState(() {
                              isPressed = false;
                            });
                            var create = await CreateTransactionApi().create();
                            final finalController =
                                Get.put(FinalStepsController());
                            finalController.setTransactioin(create!);

                            log('here:${create.payinAddress}');
                            Get.to(() => const FinalStepsPage());
                          }
                        } else {
                          setState(() {
                            isPressed = false;
                          });
                          Get.snackbar('توجه!', "آدرس وارد شده معتبر نیست");
                        }
                      }
                    },
                  ),
          ),
        ],
      );
    });
  }
}
