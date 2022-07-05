import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../backend/models/get_transaction_status_model.dart';
import '../../backend/models/currency_model.dart';
import '../network_constants.dart';

class GetTransactionStatusApi {
  Future<List<CurrencyModel>> getExchangeRate() async {
    List<CurrencyModel> list = [];
    http.Response response = await http.post(
        Uri.parse(baseUrl + getTransactionStatusEndpoint),
        body: json.encode({"transactionId": "3ab2aa7958f515"}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body)['data']['transactionStatus'];

      var decodedData = GetTransactionStatusModel.fromJson(data);
      log('$decodedData');
      return list;
    } else {
      log("${response.statusCode}");
      return list;
    }
  }
}
