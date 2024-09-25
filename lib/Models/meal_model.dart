import 'dart:convert';

List<Meals> mealsFromJson(String str) =>
    List<Meals>.from(json.decode(str).map((x) => Meals.fromJson(x)));

class Meals {
  final String id;
  final String name;
  final String category;
  final List<dynamic> imageUrl;
  final List<dynamic> components;
  final List<dynamic> ?options;
  final String price;
  final String description;
  final String title;
  final int qty;

  Meals(
      {
        required this.id,
      required this.name,
      required this.category,
      required this.imageUrl,
      required this.price,
      required this.description,
      required this.title,
      required this.components,
      required this.options,
      this.qty = 1});

  factory Meals.fromJson(Map<dynamic, dynamic> json) => Meals(
        id: json["id"],
        name: json["name"],
        category: json["category"] ?? "",
        imageUrl: json['imageUrl'],
        // List<dynamic>.from(json["imageUrl"].map((x) => x)),
        price: json["price"],
        description: json["description"] ?? "",
        title: json["title"] ?? "",
        components: json["components"] != null
            ? List<dynamic>.from(json["components"].map((x) => x))
            : [],
        options: json["options"] != []
            ? List<dynamic>.from(json["options"].map((x) => x))
            : [],
      );


  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'category': category,
        'components': components,
        'price': price,
        'imageUrl': imageUrl,
        'options': options,
        'qty': qty
      };
}
