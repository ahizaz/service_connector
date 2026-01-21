class EarningsModel {
  final String totalEarnings;
  final String availableBalance;
  final String lastMonthEarnings;
  final int activeHires;
  final int cancelledWorks;
  final int totalHired;

  EarningsModel({
    required this.totalEarnings,
    required this.availableBalance,
    required this.lastMonthEarnings,
    required this.activeHires,
    required this.cancelledWorks,
    required this.totalHired,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      totalEarnings: json['total_earnings']?.toString() ?? '0.00',
      availableBalance: json['available_balance']?.toString() ?? '0.00',
      lastMonthEarnings: json['last_month_earnings']?.toString() ?? '0.00',
      activeHires: json['active_hires'] ?? 0,
      cancelledWorks: json['cancelled_works'] ?? 0,
      totalHired: json['total_hired'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_earnings': totalEarnings,
      'available_balance': availableBalance,
      'last_month_earnings': lastMonthEarnings,
      'active_hires': activeHires,
      'cancelled_works': cancelledWorks,
      'total_hired': totalHired,
    };
  }
}
