class Expense {
String id;
String category;
double amount;
DateTime date;


Expense({required this.id, required this.category, required this.amount, required this.date});


Map<String, dynamic> toMap() => {
'category': category,
'amount': amount,
'date': date.toIso8601String(),
};


factory Expense.fromMap(String id, Map<String, dynamic> map) => Expense(
id: id,
category: map['category'] as String,
amount: (map['amount'] as num).toDouble(),
date: DateTime.parse(map['date'] as String),
);
}