class Goal {
String id;
String title;
double targetAmount;
double savedAmount;


Goal({required this.id, required this.title, required this.targetAmount, required this.savedAmount});


Map<String, dynamic> toMap() => {
'title': title,
'targetAmount': targetAmount,
'savedAmount': savedAmount,
};


factory Goal.fromMap(String id, Map<String, dynamic> map) => Goal(
id: id,
title: map['title'] as String,
targetAmount: (map['targetAmount'] as num).toDouble(),
savedAmount: (map['savedAmount'] as num).toDouble(),
);
}