import 'package:flutter/material.dart';
import 'package:community_connect/badge.dart';
import 'package:community_connect/util.dart';


Container treeCoinIcon(double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(width: size * .1, color: Colors.greenAccent[700]!),
  ),
  child: Icon(Icons.park, size: size * .75, color: Colors.greenAccent[700]!,),
);

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int baseAchievementSpaces = (badges["achievement"]!.length/3).round();
    int totalAchievementSpaces = (baseAchievementSpaces / 3).ceil() * 9;
    List<int> achievementIndices = [];
    int achievementIndex = 0;
    for (int i = 0; i < totalAchievementSpaces; i++) {
      if (i % (totalAchievementSpaces/3) <= baseAchievementSpaces - 1) {
        achievementIndices.add(achievementIndex);
        achievementIndex++;
      } else {
        achievementIndices.add(-1);
      }
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  treeCoinIcon(30),
                  const SizedBox(width: 10,),
                  Text(formatNumber(187823723822332, firstDigitsExponent: 15, digitsExponent: 4), style: TextStyle(fontSize: 30),), // TODO: Get TreeCoin amount from database.
                ],
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(5.0),
              itemCount: badges["buyable"]!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                String badgeId = badges["buyable"]![index];
                bool hasBadge = false; // TODO: Check if user has badge already.

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    foregroundDecoration: hasBadge ? BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: BorderRadius.circular(10),
                    ) : null,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[100],
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () {
                        if (hasBadge) {
                          return;
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: getBadgeImage(badgeId),
                          ),
                          Text(badgeId[0].toUpperCase() + badgeId.substring(1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              treeCoinIcon(20),
                              SizedBox(width: 4,),
                              const Text("100"),
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
              child: Text("Achievement Badges", style: TextStyle(fontSize: 25),),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(5.0),
              itemCount: totalAchievementSpaces,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                if (achievementIndices[index] == -1) {
                  return Container();
                }
                String badgeId = badges["achievement"]![achievementIndices[index]];
                String badgeName = badgeNames[badgeId]!;

                bool hasBadge = false; // TODO: Check if user has badge already.

                return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      foregroundDecoration: hasBadge ? BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        borderRadius: BorderRadius.circular(10),
                      ) : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: getBadgeImage(badgeId),
                            ),
                            Text(badgeName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                          ],
                        )
                      ),
                    )
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
