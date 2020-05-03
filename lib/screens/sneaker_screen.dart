import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SneakerScreen extends StatefulWidget {
  final Sneaker sneaker;

  SneakerScreen({this.sneaker});

  @override
  _SneakerScreenState createState() => _SneakerScreenState();
}

class _SneakerScreenState extends State<SneakerScreen> {
  String releaseDate = 'Unknown';
  String price;

  @override
  void initState() {
    super.initState();
    DateTime releaseDateTime = DateTime.parse(widget.sneaker.releaseDate);
    releaseDate = DateFormat.yMMMMd('en_US').format(releaseDateTime);

    if (widget.sneaker.price == null || widget.sneaker.price == 0) {
      price = 'Unknown';
    } else {
      price = widget.sneaker.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.sneaker.bigImage,
            placeholder: (_, __) => Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) =>
                Image.asset('assets/images/no_image.png'),
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.sneaker.name,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: <TextSpan>[
                TextSpan(
                    text: 'Release date: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: releaseDate),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: <TextSpan>[
                TextSpan(
                    text: 'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '$price USD'),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Divider(
            thickness: 3.0,
            indent: 90.0,
            endIndent: 90.0,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Friends that own this shoe:',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          )
        ],
      ),
    );
  }
}
