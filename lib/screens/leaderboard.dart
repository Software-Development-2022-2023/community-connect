import 'package:flutter/material.dart';
import 'package:community_connect/util.dart';

import '../badge.dart';
import '../data.dart';


class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 40.0, top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      "User",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(),
                  Text(
                    "Followers",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: Data.getOrderedUsers(),
            builder: (BuildContext context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                int rank = index + 1;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    decoration: rank > 3 ? null : BoxDecoration(
                                        borderRadius: BorderRadius.circular(5), color: (rank == 1) ? Colors.amberAccent[100] :
                                    (rank == 2) ? Colors.blueGrey[100] :
                                    Colors.brown[200]
                                    ),
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 5,),
                                        Container(
                                          child: Text("$rank",
                                            style: rank > 3 ? Theme.of(context).textTheme.headline6 :
                                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                                                color: (rank == 1) ? Colors.amber[900] :
                                                (rank == 2) ? Colors.blueGrey[500] :
                                                Colors.brown[600]
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundImage: badges.containsKey(snapshot.data![index][0]) ? badges[snapshot.data![index][0]]!.assetImage : null,
                                              ),
                                              SizedBox(width: 7,),
                                              Text(snapshot.data![index][1]),
                                            ],
                                          ),
                                        ),
                                        Text("${formatNumber(snapshot.data![index][2], digitsExponent: 4)}"),
                                        SizedBox(width: 20,),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
