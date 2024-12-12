import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExpenseModel {
  String title;
  int amount;
  bool amountType;
  ExpenseModel({
    required this.title,
    required this.amount,
    required this.amountType,
  });

  ExpenseModel copyWith({
    String? title,
    int? amount,
    bool? amountType,
  }) {
    return ExpenseModel(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      amountType: amountType ?? this.amountType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'amount': amount,
      'amountType': amountType,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      title: map['title'] as String,
      amount: map['amount'] as int,
      amountType: map['amountType'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) => ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
