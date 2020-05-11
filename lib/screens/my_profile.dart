import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/provider_models/follower_num.dart';
import 'package:flex/provider_models/following_list.dart';
import 'package:flex/provider_models/following_num.dart';
import 'package:flex/screens/loading.dart';
import 'package:flex/screens/user_screen.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Values that this screen consumes:
//  -display name of current user

//This screen is never pushed to navigation stack
//Parent: Home
class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentUserDisplayName = Provider.of<String>(context);

    return MultiProvider(
      child: StreamBuilder<DocumentSnapshot>(
        stream:
            DatabaseHelper(currentUserDisplayName).getDocumentFromDisplayName(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //TODO: Return error ui
            return Container();
          } else if (snapshot.hasData && snapshot.data.data != null) {
            return UserScreen(
              currentUserDisplayName: currentUserDisplayName,
              doc: snapshot.data,
            );
          } else {
            return Loading();
          }
        },
      ),
      providers: [
        StreamProvider<FollowingList>.value(
          value: DatabaseHelper(currentUserDisplayName).getFollowing(),
          initialData: FollowingList(),
          catchError: (_, error) {
            log(error.toString());
            return FollowingList();
          },
        ),
        StreamProvider<FollowerNum>.value(
          value: DatabaseHelper(currentUserDisplayName).getNumFollowers(),
          initialData: FollowerNum(),
          catchError: (_, error) {
            log(error.toString());
            return FollowerNum();
          },
        ),
        StreamProvider<FollowingNum>.value(
          value: DatabaseHelper(currentUserDisplayName).getNumFollowing(),
          initialData: FollowingNum(),
          catchError: (_, error) {
            log(error.toString());
            return FollowingNum();
          },
        ),
      ],
    );
  }
}
