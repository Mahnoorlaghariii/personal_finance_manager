class Income {
String id;
String source; // e.g., Salary, Freelance
double amount;
DateTime date;


Income({required this.id, required this.source, required this.amount, required this.date});


Map<String, dynamic> toMap() => {
'source': source,
'amount': amount,
'date': date.toIso8601String(),
};


factory Income.fromMap(String id, Map<String, dynamic> map) => Income(
id: id,
source: map['source'] as String,
amount: (map['amount'] as num).toDouble(),
date: DateTime.parse(map['date'] as String),
);
}