import 'package:flutter/material.dart';
import 'package:community_connect/util.dart';


class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  List<List<dynamic>> _getUsers() {
    // TODO: Return an *ordered* list in the format [[badgeID, username, followers, rank]].
    List<List<dynamic>> users = [
      ["", "TestUsername", 8932748743],
      ["", "skdfjlkdsjfldsjfjfldskjfdslk", 839749328],
      ["", "dfkjlfs", 8397328],
      ["", "dfsldfsdfsdskj", 9328],
      ["", "k", 9328],
      ["", "kskjldfdfskjldfsdfsdfs", 3],
      ["", "dfskjl", 1],
      ["", "dfkjlfs", 8397328],
      ["", "dfsldfsdfsdskj", 9328],
      ["", "k", 9328],
      ["", "kskjldfdfskjldfsdfsdfs", 3],
      ["", "dfskjl", 1],
      ["", "dfkjlfs", 8397328],
      ["", "dfsldfsdfsdskj", 9328],
      ["", "k", 9328],
      ["", "kskjldfdfskjldfsdfsdfs", 3],
      ["", "dfskjl", 1],
      ["", "dfkjlfs", 8397328],
      ["", "dfsldfsdfsdskj", 9328],
      ["", "k", 9328],
      ["", "kskjldfdfskjldfsdfsdfs", 3],
      ["", "dfskjl", 1],
      ["", "dfkjlfs", 8397328],
      ["", "dfsldfsdfsdskj", 9328],
      ["", "k", 9328],
      ["", "kskjldfdfskjldfsdfsdfs", 3],
      ["", "dfskjl", 1],
      ["", "dfkjlfs", 8397328],
      ["", "dfsldfsdfsdskj", 9328],
      ["", "k", 9328],
      ["", "kskjldfdfskjldfsdfsdfs", 3],
      ["", "dfskjl", 1],
    ];

    int rank = 0;
    for (int i = 0; i < users.length; i++) {

      if (i == 0 || users[i][2] != users[i-1][2]) {
        rank = i + 1;
      }
      users[i].add(rank);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> users = _getUsers();

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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          int rank = users[index][3];
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
                                          backgroundImage: null, // TODO. User users[index][0].
                                        ),
                                        SizedBox(width: 7,),
                                        Text(users[index][1]),
                                      ],
                                    ),
                                  ),
                                  Text("${formatNumber(users[index][2], digitsExponent: 4)}"),
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
          ),
        ],
      ),
    );
  }
}
