import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SneakerScreen extends StatefulWidget {
  final Sneaker sneaker;
  final bool sneakerInList;
  final String displayName;

  SneakerScreen({@required this.sneaker,
    @required this.sneakerInList,
    @required this.displayName});

  @override
  _SneakerScreenState createState() => _SneakerScreenState();
}

class _SneakerScreenState extends State<SneakerScreen> {
  String _releaseDate = 'Unknown';
  String _price;

  //true if the sneaker is in the current user's sneaker collection
  bool _sneakerInList;

  @override
  void initState() {
    super.initState();
    DateTime releaseDateTime = DateTime.parse(widget.sneaker.releaseDate);
    _releaseDate = DateFormat.yMMMMd('en_US').format(releaseDateTime);

    if (widget.sneaker.price == null || widget.sneaker.price == 0) {
      _price = 'Unknown';
    } else {
      _price = widget.sneaker.price.toString();
    }

    _sneakerInList = widget.sneakerInList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                TextSpan(text: _releaseDate),
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
                TextSpan(text: '$_price USD'),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          _sneakerInList
              ? _addedToCollectionButton()
              : _addToCollectionButton(),
          const SizedBox(height: 10.0),
          const Divider(
            thickness: 3.0,
            indent: 90.0,
            endIndent: 90.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Friends that own this shoe:',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          )
        ],
      ),
    );
  }

  Widget _addToCollectionButton() {
    return Align(
      child: RaisedButton(
        onPressed: () async {
          bool success = await DatabaseHelper(widget.displayName)
              .addSneakerToCollection(widget.sneaker);
          setState(() {
            if (success) {
              _sneakerInList = true;
            }
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.add),
            Text('Add to collection'),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }

  Widget _addedToCollectionButton() {
    return Align(
      child: FlatButton(
        onPressed: () => null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check),
            Text('Added to collection'),
          ],
        ),
        textColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
}
