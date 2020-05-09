import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flutter/material.dart';

class SneakerTile extends StatefulWidget {
  final Sneaker sneaker;
  final void Function(BuildContext context, Sneaker s) onTap;
  final String displayName;
  final bool showMenu;
  final bool contains;

  const SneakerTile({
    @required this.sneaker,
    @required this.onTap,
    this.displayName = '',
    this.showMenu = true,
    this.contains = false,
  });

  @override
  _SneakerTileState createState() => _SneakerTileState();
}

class _SneakerTileState extends State<SneakerTile> {
  bool contains;

  @override
  void initState() {
    contains = widget.contains;
    super.initState();
  }

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
                  contains = !contains;
                });
              },
              itemBuilder: (context) =>
              <PopupMenuEntry<String>>[
                contains
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
