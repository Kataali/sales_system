enum DepositStatus {
  active,
  used,
  refunded,
  expired,
}

class Deposit {
  final int id;
  final String customerName;
  final String? customerEmail;
  final String? customerPhone;
  final double amount;
  final double remainingAmount;
  final double usedAmount;
  final String? description;
  final DepositStatus status;
  final DateTime? expiryDate;
  final DateTime? usedAt;
  final int createdBy;
  final int? usedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DepositCreator? creator;
  final DepositUser? user;

  Deposit({
    required this.id,
    required this.customerName,
    this.customerEmail,
    this.customerPhone,
    required this.amount,
    required this.remainingAmount,
    required this.usedAmount,
    this.description,
    required this.status,
    this.expiryDate,
    this.usedAt,
    required this.createdBy,
    this.usedBy,
    required this.createdAt,
    required this.updatedAt,
    this.creator,
    this.user,
  });
}

class DepositCreator {
  final String name;
  final String email;

  DepositCreator({
    required this.name,
    required this.email,
  });
}

class DepositUser {
  final String name;
  final String email;

  DepositUser({
    required this.name,
    required this.email,
  });
}

class DepositStats {
  final List<DepositStatusBreakdown> statusBreakdown;
  final DepositActiveSummary activeDeposits;
  final List<DepositRecent> recentDeposits;

  DepositStats({
    required this.statusBreakdown,
    required this.activeDeposits,
    required this.recentDeposits,
  });
}

class DepositStatusBreakdown {
  final DepositStatus status;
  final int count;
  final double totalAmount;
  final double totalRemaining;
  final double totalUsed;

  DepositStatusBreakdown({
    required this.status,
    required this.count,
    required this.totalAmount,
    required this.totalRemaining,
    required this.totalUsed,
  });
}

class DepositActiveSummary {
  final int count;
  final double totalRemainingAmount;

  DepositActiveSummary({
    required this.count,
    required this.totalRemainingAmount,
  });
}

class DepositRecent {
  final int id;
  final String customerName;
  final double amount;
  final double remainingAmount;
  final double usedAmount;
  final DepositStatus status;
  final DateTime createdAt;
  final String createdBy;

  DepositRecent({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.remainingAmount,
    required this.usedAmount,
    required this.status,
    required this.createdAt,
    required this.createdBy,
  });
}

class DepositPagination {
  final int total;
  final int page;
  final int pages;
  final int limit;

  DepositPagination({
    required this.total,
    required this.page,
    required this.pages,
    required this.limit,
  });
}
