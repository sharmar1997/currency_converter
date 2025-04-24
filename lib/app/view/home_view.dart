// lib/app/view/home_view.dart
import 'package:currency_converter_application/app/controller/currency_controller.dart';
import 'package:currency_converter_application/app/view/components/currency_dropdown.dart';
import 'package:currency_converter_application/app/view/components/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurrencyController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else {
          return buildCurrencyConverterUI(context, controller);
        }
      }),
    );
  }

  Widget buildCurrencyConverterUI(BuildContext context, CurrencyController controller) {
    return Column(
      children: [
        Container(
          height: 0.4,
          color: Colors.black.withOpacity(0.1),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CurrencyTextField(isBaseCurrency: true),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: CurrencyDropdown(
                          selectedCurrency: controller.baseCurrency,
                          isBaseCurrency: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    icon: const Icon(Icons.swap_vert, size: 40, color: Colors.black),
                    onPressed: controller.swapCurrencies,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CurrencyTextField(isBaseCurrency: false),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: CurrencyDropdown(
                          selectedCurrency: controller.targetCurrency,
                          isBaseCurrency: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Divider(thickness: 2, height: 3),
                  Obx(() {
                    final rate = controller.baseCurrency.value
                        .convert(1.0, controller.targetCurrency.value);
                    return RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                        children: [
                          TextSpan(
                            text: '1 ${controller.baseCurrency.value.code} = ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: '${rate.toStringAsFixed(6)} ${controller.targetCurrency.value.code}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(thickness: 2, height: 3),
                  SizedBox(
                    height: 50
                  ),
                  Obx(() {
                    final history = controller.searchHistory;
                    return Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conversion History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...history.map((entry) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.history, size: 18),
                                const SizedBox(width: 8),
                                Text(entry),
                            ]),
                          ))
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
