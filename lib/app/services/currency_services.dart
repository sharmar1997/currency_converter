// lib/app/service/exchange_rate_service.dart
import 'dart:convert';
import 'package:currency_converter_application/app/model/currency_model.dart';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  static const String _baseUrl = 'https://open.er-api.com/v6/latest/USD';

  final Map<String, String> currencyflags = {
    'USD': 'assets/images/us.png',
    'INR': 'assets/images/india.png',
    'EUR': 'assets/images/uk.png',
    'CAD': 'assets/images/cana.png',
    'KWD': 'assets/images/kuwait.png',
    'CNY': 'assets/images/china.png',
    'JPY': 'assets/images/japan.png',
  };

  Future<List<Currency>> fetchExchangeRates() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final rates = data['rates'] as Map<String, dynamic>;

        final List<Currency> currencyList = rates.entries.map((entry) {
          return Currency(
            code: entry.key,
            name: entry.key,
            symbol: entry.key,
            rateToUSD: (entry.value as num).toDouble(),
          );
        }).toList();

        return currencyList;
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
