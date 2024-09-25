import 'dart:convert';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  final int id;
  final String clientName;
  final String tableNumber;
  final List<dynamic> meals;
  final double totalAmount;
  final String note;
  final String status;

  Order(
      {
        required this.id,
      required this.clientName,
      required this.tableNumber,
      required this.meals,
      required this.totalAmount,
      required this.status,
        this.note = ""});

  factory Order.fromJson(Map<String, dynamic> json) {
    // var list = json['meals'] as List;
    // List<Meals> mealList = list.map((i) => Meals.fromJson(i)).toList();
    return Order(
        id: json['id'],
        tableNumber: json['tableNumber'],
        meals:json['meals'],
        // List<Meals>.from(json["meals"].map((x) => x)),
        totalAmount: json['totalAmount'],
        note: json['note'],
        clientName: json['clientName'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tableNumber': tableNumber,
        'meals':
        // meals,
        meals.map((meal) => meal.toJson()).toList(),
        'totalAmount': totalAmount,
        'note': note,
        'clientName': clientName,
    'status': status
      };
}
