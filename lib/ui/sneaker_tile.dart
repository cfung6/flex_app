import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flutter/material.dart';

class SneakerTile extends StatelessWidget {
  final Sneaker sneaker;
  final void Function(Sneaker s) onTap;

  const SneakerTile({@required this.sneaker, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
//                      FadeInImage.assetNetwork(
//                        height: 150,
//                        width: 150,
//                        image: sneaker.smallImage,
//                        placeholder: 'assets/images/no_image.png',
//                      ),
                      CachedNetworkImage(
                        width: 150,
                        imageUrl: sneaker.smallImage,
                        placeholder: (_, __) => CircularProgressIndicator(),
                        errorWidget: (_, __, ___) =>
                            Image.asset('assets/images/no_image.png'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        sneaker.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  onTap(sneaker);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
