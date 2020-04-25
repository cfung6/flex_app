import 'package:flex/screens/search.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final SearchState searchPage;

  const SearchBar({
    @required this.controller,
    @required this.focusNode,
    @required this.searchPage,
  });

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateIfEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final widthMax = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 60.0,
        width: widthMax,
        decoration: BoxDecoration(
          color: Color.fromRGBO(142, 142, 147, .15),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.black),
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 20.0),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search),
                    suffixIcon: _isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              widget.controller.clear();
                              widget.searchPage.updateQuery();
                            },
                          ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateIfEmpty() {
    setState(() {
      _isEmpty = widget.controller.text == "";
    });
  }
}
