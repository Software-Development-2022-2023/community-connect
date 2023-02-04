import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';


List<String> badgeIds = [];

Map<String, BadgeInfo> badges = {};

class BadgeInfo {
  final String id;
  final String name;
  final String type;
  final AssetImage assetImage;
  final int value;
  final int cost;

  BadgeInfo(
    this.id,
    this.name,
    this.type,
    this.assetImage,
    {this.value = 0,
    this.cost = 0}
  ) {
    badges[id] = this;
    badgeIds.add(id);
  }
}


Future<void> getBadges() async {
  final yamlString = await rootBundle.loadString('assets/badges/badges.yaml');
  final badgeData = loadYaml(yamlString);
  badgeData.forEach((type, badgeMap) {
    badgeMap.forEach((badgeId, information) {
      void createBadge(id, name, {cost = 0, value = 0}) {
        BadgeInfo(
          id,
          name,
          type,
          AssetImage('assets/badges/$type/$id.jpeg'),
          cost: cost,
          value: value,
        );
      }
      if (type == "buyable") {
        createBadge(
            badgeId,
            badgeId[0].toUpperCase() + badgeId.substring(1),
            cost: information["cost"]);
      } else if (type == "achievement") {
        information.forEach((number, value) {
          createBadge(
            "$badgeId$number",
            (badgeId != "time") ?
              "$number ${badgeId[0].toUpperCase() + badgeId.substring(1, (number != 1) ? badgeId.length : badgeId.length - 1)}" :
              "${(number < 12 ? number : (number / 12).round())}-${(number < 12) ? "Month" : "Year"} User",
            value: value["value"],
          );
        });
      }
    });
  });
}
