class Budget {
double monthlyLimit;
DateTime month; 


Budget({required this.monthlyLimit, required this.month});


Map<String, dynamic> toMap() => {
'monthlyLimit': monthlyLimit,
'month': DateTime(month.year, month.month).toIso8601String(),
};


factory Budget.fromMap(Map<String, dynamic> map) => Budget(
monthlyLimit: (map['monthlyLimit'] as num).toDouble(),
month: DateTime.parse(map['month'] as String),
);


Budget copyWith({double? monthlyLimit, DateTime? month}) => Budget(
monthlyLimit: monthlyLimit ?? this.monthlyLimit,
month: month ?? this.month,
);
}