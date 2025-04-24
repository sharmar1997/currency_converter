import 'package:currency_converter_application/app/controller/currency_controller.dart';
import 'package:currency_converter_application/app/model/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class CurrencyDropdown extends StatelessWidget {
  final Rx<Currency> selectedCurrency;
  final bool isBaseCurrency;

  const CurrencyDropdown({
    super.key,
    required this.isBaseCurrency,
    required this.selectedCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final CurrencyController currenyController = Get.find();

    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 134, 133, 133)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: DropdownButton<Currency>(
          value: selectedCurrency.value,
          items: currenyController.currencies.map((Currency currency) {
            return DropdownMenuItem<Currency>(
              value: currency,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    currency.name,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: (Currency? newValue) {
            if (newValue != null) {
              selectedCurrency.value = newValue;
              currenyController.convertCurrency();
            }
          },
          underline: const SizedBox(),
          isExpanded: true,
        ),
      );
    });
  }
}