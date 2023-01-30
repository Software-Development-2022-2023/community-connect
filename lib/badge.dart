import 'package:flutter/material.dart';
import 'dart:math';


Map<String, List<String>> badges = {
  "achievement": [
    "favorites1",
    "favorites2",
    "favorites3",
    "favorites4",
    "favorites5",
    "followers1",
    "followers2",
    "followers3",
    "followers4",
    "followers5",
    "time1",
    "time2",
    "time3",
    "time4",
    "time5",
  ],
  "buyable": [
    "bird",
    "landscape",
    "fairy",
    "flower",
    "ladybug",
    "moon",
  ],
};

Map<String, String> badgeNames = {
  "favorites1": "10 Favorites",
  "favorites2": "100 Favorites",
  "favorites3": "1,000 Favorites",
  "favorites4": "10,000 Favorites",
  "favorites5": "100,000 Favorites",
  "followers1": "1 Follower",
  "followers2": "10 Followers",
  "followers3": "100 Followers",
  "followers4": "1000 Followers",
  "followers5": "10,000 Followers",
  "time1": "1 Month User",
  "time2": "6 Month User",
  "time3": "1 Year User",
  "time4": "5 Year User",
  "time5": "10 Year User",
};


String? getBadgeId(String category, dynamic value) {
  if (category != "time") {
    value = log(value) / log(10);
    if (category == "followers") {
      value++;
    }
  } else { // TODO: If value is a time. Not sure what data type firebase will return.

  }
  return "$category${value.round()}}";
}

ImageProvider getBadgeImage(String badgeId) {
  String badgeType = badges["buyable"]!.contains(badgeId) ? "buyable" : "achievement";
  if (badgeType == "achievement" && !badges["achievement"]!.contains(badgeId)) {
    throw Exception("Invalid badge ID: $badgeId");
  }

  return AssetImage('assets/badges/$badgeType/$badgeId.jpeg');
}

