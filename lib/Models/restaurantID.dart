import 'dart:convert';

class Restaurant {
  String restaurantNameEN;
  String restaurantNameAR;
  // String sloganEN;
  // String sloganAR;
  String logo;

  Restaurant({
    required this.restaurantNameEN,
    required this.restaurantNameAR,
    // required this.sloganEN,
    // required this.sloganAR,
    required this.logo,
  });

  // Create a Restaurant object from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantNameEN: json['restaurantNameEN'],
      restaurantNameAR: json['restaurantNameAR'],
      // sloganEN: json['sloganEN'],
      // sloganAR: json['sloganAR'],
      logo: json['logo'],
    );
  }

  // Convert the Restaurant object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'restaurantNameEN': restaurantNameEN,
      'restaurantNameAR': restaurantNameAR,
      // 'sloganEN': sloganEN,
      // 'sloganAR': sloganAR,
      'logo': logo,
    };
  }
}
