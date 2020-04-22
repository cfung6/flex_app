import 'package:flutter/material.dart';

class Sneaker {
  final String name;
  final int price;
  final String releaseDate;
  final String bigImage, medImage, smallImage;

  const Sneaker({
    @required this.name,
    @required this.price,
    @required this.releaseDate,
    @required this.bigImage,
    @required this.medImage,
    @required this.smallImage,
  });

  factory Sneaker.fromJSON(Map<String, dynamic> json, int i) {
    return Sneaker(
      name: json['results'][i]['title'],
      price: json['results'][i]['retailPrice'],
      releaseDate: json['results'][i]['releaseDate'],
      bigImage: json['results'][i]['media']['imageUrl'],
      medImage: json['results'][i]['media']['smallImageUrl'],
      smallImage: json['results'][i]['media']['thumbUrl'],
    );
  }
}
