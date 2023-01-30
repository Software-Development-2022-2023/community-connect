import 'package:flutter/material.dart';


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
    "digital_landscape",
    "fairy",
    "flower",
    "ladybug",
    "moon",
  ],
};

Map<String, String> badgeIds = {
  "10 Favorites": "favorites1",
  "100 Favorites": "favorites2",
  "1000 Favorites": "favorites3",
  "10000 Favorites": "favorites4",
  "100000 Favorites": "favorites5",
  "1 Follower": "followers1",
  "10 Followers": "followers2",
  "100 Followers": "followers3",
  "1000 Followers": "followers4",
  "10000 Followers": "followers5",
  "1 Month User": "time1",
  "6 Month User": "time2",
  "1 Year User": "time3",
  "5 Year User": "time4",
  "10 Year User": "time5",
};

String? getBadgeId(String category, dynamic value) {
  if (value is int && value == 1) {
    category = category.substring(0, category.length - 1);
  } else { // TODO: If value is a time. Not sure what data type firebase will return.
    category = " User"; // TODO: Add "Month" or "Year".
  }
  return "$value ${category[0].toUpperCase()}${category.substring(1)}";
}

ImageProvider getBadgeImage(String badgeId) {
  String badgeType = badges["buyable"]!.contains(badgeId) ? "buyable" : "achievement";
  if (badgeType == "achievement" && !badges["achievement"]!.contains(badgeId)) {
    throw Exception("Invalid badge ID: $badgeId");
  }

  return AssetImage('assets/badges/$badgeType/$badgeId.jpeg');
}

