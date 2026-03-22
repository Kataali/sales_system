class CheckoutResult {
  final bool success;
  final String message;
  final List<int> saleIds;
  final int saleCount;
  final double totalAmount;

  CheckoutResult({
    required this.success,
    required this.message,
    required this.saleIds,
    required this.saleCount,
    required this.totalAmount,
  });

  factory CheckoutResult.fromJson(Map<String, dynamic> json) {
    final sales = (json['sales'] as List?) ?? [];

    final saleIds = sales.map((e) => e['id'] as int).toList();

    final totalAmount = sales.fold<double>(0.0, (sum, e) {
      final value = e['totalAmount'];
      return sum + double.parse(value.toString());
    });

    return CheckoutResult(
      success: json['success'],
      message: json['message'],
      saleIds: saleIds,
      saleCount: sales.length,
      totalAmount: totalAmount,
    );
  }
}
