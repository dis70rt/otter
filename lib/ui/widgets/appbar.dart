import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otter/services/database_provider.dart';

import 'search_bar.dart';

AppBar buildAppbar(dynamic authProvider, BuildContext context,
    FireStoreProvider dbProvider, int selectedIndex) {
  return AppBar(
    flexibleSpace: ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(color: Colors.transparent),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      side: BorderSide(color: Colors.white10, width: 2),
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    leading: GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              authProvider.user?.photoURL ?? "https://i.imgur.com/WxNkK7J.png"),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    ),
    elevation: 10,
    actions: [
      IconButton(
        icon: const Icon(Icons.logout_outlined, color: Colors.white),
        onPressed: () {},
      )
    ],
    centerTitle: true,
    title: const Text(
      "OTTER",
      style: TextStyle(
          color: Colors.white, letterSpacing: 8, fontWeight: FontWeight.w900),
    ),
    bottom: selectedIndex == 2
        ? PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 80),
            child: buildSearchBar(dbProvider),
          )
        : PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 10),
            child: const AnimatedSize(
              duration: Duration(seconds: 1), curve: Curves.easeIn,)),
  );
}
