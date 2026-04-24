import '../../domain/entities/deposit.dart';

class DepositModel extends Deposit {
  DepositModel({
    required int id,
    required String customerName,
    String? customerEmail,
    String? customerPhone,
    required double amount,
    required double remainingAmount,
    required double usedAmount,
    String? description,
    required DepositStatus status,
    DateTime? expiryDate,
    DateTime? usedAt,
    required int createdBy,
    int? usedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DepositCreator? creator,
    DepositUser? user,
  }) : super(
          id: id,
          customerName: customerName,
          customerEmail: customerEmail,
          customerPhone: customerPhone,
          amount: amount,
          remainingAmount: remainingAmount,
          usedAmount: usedAmount,
          description: description,
          status: status,
          expiryDate: expiryDate,
          usedAt: usedAt,
          createdBy: createdBy,
          usedBy: usedBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          creator: creator,
          user: user,
        );

  factory DepositModel.fromJson(Map<String, dynamic> json) {
    return DepositModel(
      id: json['id'],
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      customerPhone: json['customerPhone'],
      amount: _parseDouble(json['amount']),
      remainingAmount: _parseDouble(json['remainingAmount']),
      usedAmount: _parseDouble(json['usedAmount']),
      description: json['description'],
      status: _parseStatus(json['status']),
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      createdBy: json['createdBy'],
      usedBy: json['usedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      creator: json['creator'] != null ? DepositCreator(
        name: json['creator']['name'],
        email: json['creator']['email'],
      ) : null,
      user: json['user'] != null ? DepositUser(
        name: json['user']['name'],
        email: json['user']['email'],
      ) : null,
    );
  }
}

class DepositStatsModel extends DepositStats {
  DepositStatsModel({
    required List<DepositStatusBreakdown> statusBreakdown,
    required DepositActiveSummary activeDeposits,
    required List<DepositRecent> recentDeposits,
  }) : super(
          statusBreakdown: statusBreakdown,
          activeDeposits: activeDeposits,
          recentDeposits: recentDeposits,
        );

  factory DepositStatsModel.fromJson(Map<String, dynamic> json) {
    final statusBreakdownJson = json['statusBreakdown'] as List<dynamic>;
    final statusBreakdown = statusBreakdownJson.map((item) => DepositStatusBreakdown(
      status: _parseStatus(item['status']),
      count: item['count'],
      totalAmount: _parseDouble(item['totalAmount']),
      totalRemaining: _parseDouble(item['totalRemaining']),
      totalUsed: _parseDouble(item['totalUsed']),
    )).toList();

    final activeDepositsJson = json['activeDeposits'];
    final activeDeposits = DepositActiveSummary(
      count: activeDepositsJson['count'],
      totalRemainingAmount: _parseDouble(activeDepositsJson['totalRemainingAmount']),
    );

    final recentDepositsJson = json['recentDeposits'] as List<dynamic>;
    final recentDeposits = recentDepositsJson.map((item) => DepositRecent(
      id: item['id'],
      customerName: item['customerName'],
      amount: _parseDouble(item['amount']),
      remainingAmount: _parseDouble(item['remainingAmount']),
      usedAmount: _parseDouble(item['usedAmount']),
      status: _parseStatus(item['status']),
      createdAt: DateTime.parse(item['createdAt']),
      createdBy: item['createdBy'],
    )).toList();

    return DepositStatsModel(
      statusBreakdown: statusBreakdown,
      activeDeposits: activeDeposits,
      recentDeposits: recentDeposits,
    );
  }
}

class DepositPaginationModel extends DepositPagination {
  DepositPaginationModel({
    required int total,
    required int page,
    required int pages,
    required int limit,
  }) : super(
          total: total,
          page: page,
          pages: pages,
          limit: limit,
        );

  factory DepositPaginationModel.fromJson(Map<String, dynamic> json) {
    return DepositPaginationModel(
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      limit: json['limit'],
    );
  }
}

// Helper methods
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  if (value is num) return value.toDouble();
  return 0.0;
}

DepositStatus _parseStatus(String status) {
  switch (status) {
    case 'active':
      return DepositStatus.active;
    case 'used':
      return DepositStatus.used;
    case 'refunded':
      return DepositStatus.refunded;
    case 'expired':
      return DepositStatus.expired;
    default:
      return DepositStatus.active;
  }
}
