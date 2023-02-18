import 'package:flutter/material.dart';
import 'package:community_connect/badge.dart';
import 'package:community_connect/util.dart';

import '../data.dart';


Container treeCoinIcon(double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(width: size * .1, color: Colors.greenAccent[700]!),
  ),
  child: Icon(Icons.park, size: size * .75, color: Colors.greenAccent[700]!,),
);


class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    int achievementBadgeCount = 0;
    int buyableBadgeCount = 0;
    int achievementTypes = 0;
    badges.forEach((_, badge) {
      if (badge.type == "achievement") {
        achievementBadgeCount++;
        if (badge.id[badge.id.length - 1] == "1") {
          achievementTypes++;
        }
      } else {
        buyableBadgeCount++;
      }
    });
    int baseAchievementSpaces = (achievementBadgeCount / achievementTypes).round();
    int totalAchievementSpaces = (baseAchievementSpaces / 3).ceil() * 3 * achievementTypes;
    List<int> achievementIndices = [];
    int achievementIndex = 0;
    for (int i = 0; i < totalAchievementSpaces; i++) {
      if (i % (totalAchievementSpaces / achievementTypes) <= baseAchievementSpaces - 1) {
        achievementIndices.add(achievementIndex);
        achievementIndex++;
      } else {
        achievementIndices.add(-1);
      }
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: Data.getUserData(''),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        treeCoinIcon(30),
                        const SizedBox(width: 10,),
                        Text(
                          formatNumber(snapshot.data!['treecoins'], firstDigitsExponent: 15,
                              digitsExponent: 4), style: TextStyle(
                            fontSize: 30),),
                      ],
                    ),
                  ),
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(5.0),
                      itemCount: buyableBadgeCount,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        BadgeInfo badge = badges[badgeIds[index]]!;
                        bool hasBadge = snapshot.data!['badges'].contains(badge.id);
                        print(snapshot.data!['badges'].contains(badge.id));

                        return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              foregroundDecoration: !hasBadge ? BoxDecoration(
                                color: Colors.black.withOpacity(.6),
                                borderRadius: BorderRadius.circular(10),
                              ) : null,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent[100],
                                    foregroundColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              10)),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (hasBadge || snapshot.data!['treecoins'] < badge
                                        .cost) {
                                      return;
                                    }
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            popup(context, badge.name,
                                                "Buy this badge for ${badge
                                                    .cost} TreeCoins?")
                                    ).then((value) {
                                      if (value) {
                                        // Confirmed, try to buy badge
                                        Data.buyBadge(badge).then((succ) {
                                          if (!succ) {
                                            return;
                                          } else {
                                            setState(() {

                                            });
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: badge.assetImage,
                                      ),
                                      Text(badge.name),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          treeCoinIcon(20),
                                          const SizedBox(width: 4,),
                                          Text(badge.cost.toString()),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            )
                        );
                      }
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      "Achievement Badges", style: TextStyle(fontSize: 25),),
                  ),
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(5.0),
                      itemCount: totalAchievementSpaces,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        if (achievementIndices[index] == -1) {
                          return Container();
                        }
                        BadgeInfo badge = badges[badgeIds[achievementIndices[index] +
                            buyableBadgeCount]]!;

                        bool hasBadge = snapshot.data!['badges'].contains(badge.id);

                        return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              foregroundDecoration: !hasBadge ? BoxDecoration(
                                color: Colors.black.withOpacity(.6),
                                borderRadius: BorderRadius.circular(10),
                              ) : null,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: badge.assetImage,
                                      ),
                                      Text(badge.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight
                                                .bold, fontSize: 14),),
                                    ],
                                  )
                              ),
                            )
                        );
                      }
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }
}
