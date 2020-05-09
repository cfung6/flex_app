import 'package:flex/models/sneaker.dart';
import 'package:flex/screens/sneaker_screen.dart';
import 'package:flex/ui/sneaker_tile.dart';
import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  final List<Sneaker> viewedUsersSneakers; //collection of the user being viewed
  final List<Sneaker> currentUserSneakers;
  final String viewedUserDisplayName;
  final String currentUserDisplayName;
  final bool showMenu;
  final bool currentUserSameAsViewedUser;

  Collection({
    @required this.viewedUsersSneakers,
    @required this.viewedUserDisplayName,
    @required this.currentUserSneakers,
    @required this.currentUserDisplayName,
    this.showMenu = true,
    this.currentUserSameAsViewedUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCollectionList();
  }

  Widget _buildCollectionList() {
    List<SneakerTile> sneakerTiles = _sneakerListToSneakerTileList();

    return Expanded(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int i) {
          return sneakerTiles[i];
        },
        itemCount: sneakerTiles.length,
      ),
    );
  }

  List<SneakerTile> _sneakerListToSneakerTileList() {
    List<SneakerTile> sneakerTiles = [];

    for (int i = 0; i < viewedUsersSneakers.length; i++) {
      sneakerTiles.add(
        SneakerTile(
          sneaker: viewedUsersSneakers[i],
          onTap: _goToSneakerScreen,
          showMenu: showMenu,
          contains: currentUserSneakers.contains(viewedUsersSneakers[i]),
          displayName: currentUserDisplayName,
        ),
      );
    }

    return sneakerTiles;
  }

  void _goToSneakerScreen(BuildContext context, Sneaker s) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SneakerScreen(
          sneaker: s,
          sneakerInList: currentUserSneakers.contains(s),
          displayName: currentUserDisplayName,
        ),
      ),
    );
  }
}
