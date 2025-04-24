// lib/app/controller/currency_controller.dart
import 'package:currency_converter_application/app/model/currency_model.dart';
import 'package:currency_converter_application/app/services/currency_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CurrencyInputField { base, target }

class CurrencyController extends GetxController {
  final RxList<Currency> _allCurrencies = <Currency>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> searchHistory = <String>[].obs;

  final baseTextController = TextEditingController();
  final targetTextController = TextEditingController();

  RxDouble amount = 1.0.obs;
  RxDouble convertNumber = 0.0.obs;

  Rx<CurrencyInputField> lastEditedField = CurrencyInputField.base.obs;


  Rx<Currency> baseCurrency = Currency(
    code: 'USD',
    name: 'US Dollar',
    symbol: '\$',
    rateToUSD: 1.0,
  ).obs;

  Rx<Currency> targetCurrency = Currency(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
    rateToUSD: 0.93,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrencies();
  }

  List<Currency> get currencies => _allCurrencies;

  Currency? findCurrencyByCode(String code) {
    return _allCurrencies.firstWhereOrNull((c) => c.code == code);
  }

  Future<void> fetchCurrencies() async {
    isLoading.value = true;
    try {
      final service = ExchangeRateService();
      final currencies = await service.fetchExchangeRates();
      _allCurrencies.assignAll(currencies);

      baseCurrency.value = currencies.firstWhere((c) => c.code == 'USD', orElse: () => currencies.first);
      targetCurrency.value = currencies.firstWhere((c) => c.code == 'INR', orElse: () => currencies.last);

      baseTextController.text = amount.value.toStringAsFixed(2);
      convertCurrency();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void convertCurrency() {
    if (lastEditedField.value == CurrencyInputField.base) {
      convertNumber.value = baseCurrency.value.convert(amount.value, targetCurrency.value);
      targetTextController.text = convertNumber.value.toStringAsFixed(2);
    } else {
      amount.value = targetCurrency.value.convert(convertNumber.value, baseCurrency.value);
      baseTextController.text = amount.value.toStringAsFixed(2);
    }
    addToHistory();
  }

  void addToHistory() {
    final entry = '${amount.value.toStringAsFixed(2)} ${baseCurrency.value.code} -> ${convertNumber.value.toStringAsFixed(2)} ${targetCurrency.value.code}';
    searchHistory.remove(entry);
    searchHistory.insert(0, entry);
    if (searchHistory.length > 5) {
      searchHistory.removeLast();
    }
  }

  void swapCurrencies() {
    final temp = baseCurrency.value;
    baseCurrency.value = targetCurrency.value;
    targetCurrency.value = temp;
    convertCurrency();
  }
}
