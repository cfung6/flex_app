import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SneakerTile extends StatefulWidget {
  final Sneaker sneaker;
  final void Function(BuildContext context, Sneaker s) onTap;
  final String displayName;
  final bool showMenu;

  const SneakerTile({
    @required this.sneaker,
    @required this.onTap,
    @required this.displayName,
    this.showMenu = true,
  });

  @override
  _SneakerTileState createState() => _SneakerTileState();
}

class _SneakerTileState extends State<SneakerTile> {
  bool _contains;

  @override
  Widget build(BuildContext context) {
    _contains = Provider.of<List<Sneaker>>(context).contains(widget.sneaker);

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
                        imageUrl: widget.sneaker.smallImage,
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
                        widget.sneaker.name,
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
                  widget.onTap(context, widget.sneaker);
                },
              ),
            ),
          ),
          _returnMenuButton(widget.displayName),
        ],
      ),
    );
  }

  Widget _returnMenuButton(String displayName) {
    if (widget.showMenu) {
      return Positioned.fill(
        child: Align(
          alignment: Alignment.topRight,
          child: Material(
            child: PopupMenuButton(
              onSelected: (value) async {
                if (value == 'Remove') {
                  if (!(await DatabaseHelper(displayName)
                      .removeSneakerFromCollection(widget.sneaker))) {
                    //TODO: Return Error
                    log('error removing');
                  }
                } else if (value == 'Add') {
                  if (!(await DatabaseHelper(displayName)
                      .addSneakerToCollection(widget.sneaker))) {
                    //TODO: Return Error
                    log('error adding');
                  }
                }
                setState(() {
                  _contains = !_contains;
                });
              },
              itemBuilder: (context) =>
              <PopupMenuEntry<String>>[
                _contains
                    ? const PopupMenuItem<String>(
                  value: 'Remove',
                  child: Text('Remove from collection'),
                )
                    : const PopupMenuItem<String>(
                  value: 'Add',
                  child: Text('Add to collection'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }
}
