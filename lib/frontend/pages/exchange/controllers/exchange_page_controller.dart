import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../backend/api/check_pair_be_vaild.dart';
import '../../../../backend/api/estimate_exchange_amount.dart';
import '../../../../backend/api/get_exchange_rate.dart';
import '../../../../backend/models/check_pair_be_vaild_model.dart';
import '../../../../backend/models/estimate_exchange_amount_model.dart';
import '../../../../backend/models/init_tabel_model.dart';
import '../../../../backend/api/init-table.dart';
import '../../../../backend/models/currency_model.dart';

enum Button { first, second, last }

class ExchangePageController extends GetxController {
  TextEditingController textAddressController = TextEditingController();
  TextEditingController textSupportAddressController = TextEditingController();

  var isSupportAddressMustBeEmpty = false.obs;
  setSupportAddress() => isSupportAddressMustBeEmpty = true.obs;

  var isSecondBoxShow = false.obs;
  showSecondBox() => isSecondBoxShow = true.obs;

  var whichButton = Button.first.obs;
  goToNext(Button button) => whichButton = button.obs;

  RxBool connectToNetwork = false.obs;
  RxBool isIconChange = false.obs;
  RxBool isReversed = false.obs;
  var currentTopItem = 0.obs;
  var searchController = 0.obs;
  var userAddress = ''.obs;
  var supportAddress = ''.obs;
  var maximumExchangeAmount = 0.0.obs;
  var minimumExchangeAmount = 0.0.obs;
  CurrencyModel? forSellChoice;
  var forSellAmount = 0.0.obs;
  CurrencyModel? forBuyChoice;
  var forBuyAmount = 0.0.obs;
  List<CurrencyModel>? forSellList;
  List<CurrencyModel>? forBuyList;
  List<CurrencyModel>? currencyList = [];
  InitTabelModel? estimate;
  CheckPairBeVaildModel? pairBeValid;
  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }

  updateEstimateAmount(double sellAmount, double buyAmount) {
    forSellAmount = 0.0.obs;
    forBuyAmount = 0.0.obs;
    forSellAmount = sellAmount.obs;
    forBuyAmount = buyAmount.obs;
    log('////////////////////////////////////$forSellAmount');
    log('////////////////////////////////////$forSellAmount');
    update();
  }

  validation({
    CurrencyModel? currencyForBuy,
    CurrencyModel? currencyForSell,
  }) async {
    String tempType = isIconChange.value ? "fix" : "not-fix";

    pairBeValid = await CheckPairBeVaildApi().getPairBeVaild(
      type: tempType,
      sourceNetwork: currencyForSell!.inNetwork,
      sourceCurrency: currencyForSell.symbol,
      destinationNetwork: currencyForBuy!.inNetwork,
      destinationCurrency: currencyForBuy.symbol,
    );
    message(title: 'pair be vaild ', content: pairBeValid!);
    if (pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
      var exchangeRate = await GetExchangeRateApi().getExchangeRate(
        type: tempType,
        sourceNetwork: currencyForSell.inNetwork,
        sourceCurrency: currencyForSell.symbol,
        destinationNetwork: currencyForBuy.inNetwork,
        destinationCurrency: currencyForBuy.symbol,
      );
      minimumExchangeAmount = exchangeRate!.minimumExchangeAmount!.obs;
      maximumExchangeAmount = double.parse(
              exchangeRate.maximumExchangeAmount! == ''
                  ? '0'
                  : exchangeRate.maximumExchangeAmount!)
          .obs;
      EstimateExchangeAmountModel? est =
          await EstimateExchangeAmountApi().getAmount(
        type: tempType,
        sourceNetwork: currencyForSell.inNetwork,
        sourceCurrency: currencyForSell.symbol,
        destinationNetwork: currencyForBuy.inNetwork,
        destinationCurrency: currencyForBuy.symbol,
        directionOfExchangeFlow: 'direct',
        sourceAmount: minimumExchangeAmount.value,
      );
      updateEstimateAmount(
          minimumExchangeAmount.value, est!.destinationAmount ?? 0);
      log("forSellAmount :$forSellAmount");
      log("estimate amount :${est.destinationAmount}");
      message(title: 'get exchange rate ', content: exchangeRate);
    } else if (!pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
    } else {
      Get.snackbar('توجه!', "این جفت ارز با هم قابل مبادله نیستند");
    }

    update();
  }

  //check connection to network
  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        log('connected');
        connectToNetwork = true.obs;
        // get currency list
        //get init table
        var initTable = await InitTableApi().initTable();
        estimate = initTable!['estimate'] ?? [];

        updateEstimateAmount(
            estimate!.sourceAmount!, estimate!.destinationAmount!);
        log('${estimate!.destinationAmount}.');

        currencyList = initTable['list'] ?? {};

        forSellChoice = currencyList!
            .where((item) => item.engName!.toLowerCase() == 'bitcoin')
            .first;
        log("$forSellChoice");
        forBuyChoice = currencyList!
            .where((item) => item.engName!.toLowerCase() == 'ethereum')
            .first;
        log("$forBuyChoice");
        forSellList = currencyList!
            .where((item) => item.availableForSell == true)
            .toList();
        log("$forSellList");
        forBuyList = currencyList!
            .where((item) => item.availableForBuy == true)
            .toList();
        log("$forBuyList");

        update();
      }
    } on SocketException catch (_) {
      log('not connected');
      connectToNetwork = false.obs;
      update();
    }
  }

  setAddress(String address) {
    userAddress = address.obs;
    update();
  }

  updateCurrencyChoice({required CurrencyModel currency, required int item}) {
    if (item == 1) {
      forBuyChoice = currency;
      validation(currencyForBuy: forBuyChoice, currencyForSell: forSellChoice);
    } else {
      forSellChoice = currency;
      validation(currencyForBuy: forBuyChoice, currencyForSell: forSellChoice);
    }
    update();
  }

  cahngeSearchController(int index) {
    searchController = index.obs;
    update();
  }

  getCurrentTopItem(int index) {
    currentTopItem = index.obs;
    update();
  }

  RxBool isScreenChange = false.obs;
  changeScreen() {
    isScreenChange = isScreenChange.value ? false.obs : true.obs;
    update();
    message(title: 'is screen Change', content: isScreenChange.value);
  }

  changeReversed() {
    isReversed = isReversed.value ? false.obs : true.obs;
    update();
    message(title: 'is reversed', content: isReversed.value);
  }

// for dispaly lock icon (fix) or not
  changeIcon() {
    isIconChange = isIconChange.value ? false.obs : true.obs;
    update();
    message(title: 'is Icon Change', content: isIconChange.value);
  }

  message({String title = '', var content}) {
    log('$title : $content');
  }
}
