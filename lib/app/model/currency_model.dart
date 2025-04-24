class Currency {
  final String code;
  final String name;
  final String symbol;
  final double rateToUSD;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rateToUSD,
  });

  // Add equality comaprison
  @override
  bool operator == (Object other) =>
    identical(this, other) || 
    other is Currency && 
    runtimeType == other.runtimeType && 
    code == other.code;

  @override
  int get hashCode => code.hashCode;

  double convert(double amount, Currency toCurrency) {
    final usdValue = amount / rateToUSD;
    return usdValue * toCurrency.rateToUSD;
  }
}