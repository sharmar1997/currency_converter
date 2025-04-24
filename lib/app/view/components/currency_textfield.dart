
import 'package:currency_converter_application/app/controller/currency_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class CurrencyTextField extends StatelessWidget {
  final bool isBaseCurrency;

  const CurrencyTextField({super.key, required this.isBaseCurrency});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CurrencyController>();
    final textController = isBaseCurrency ? controller.baseTextController : controller.targetTextController;

    return Obx(() {
      return TextField(
        controller: textController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 12.0),
          prefixText: isBaseCurrency ? null : '=',
          suffixText: isBaseCurrency ? controller.baseCurrency.value.symbol : controller.targetCurrency.value.symbol,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onChanged: (value) {
          double parsed = double.tryParse(value) ?? 0.0;
          if (isBaseCurrency) {
            controller.lastEditedField.value = CurrencyInputField.base;
            controller.amount.value = parsed;
          } else {
            controller.lastEditedField.value = CurrencyInputField.target;
            controller.convertNumber.value = parsed;
          }
          controller.convertCurrency();
        },
      );
    });
  }
}
