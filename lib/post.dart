import 'package:flutter/material.dart';

import 'badge.dart';
import 'data.dart';


const List<String> subjectList = <String>["Recycling", "Solar Power", "Planting trees", "Renewables", "Picking up trash"];

class Post extends StatefulWidget {
  final String badge;
  final String username;
  final int time;
  final String imageUrl;
  final String caption;
  final List<String> filters;
  final LikeInfo likeInfo;
  final String postId;

  const Post({Key? key,
    required this.badge,
    required this.username,
    required this.time,
    required this.imageUrl,
    required this.caption,
    required this.filters,
    required this.likeInfo,
    required this.postId,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class LikeInfo {
  int likes;
  bool isLiked = false;

  LikeInfo(this.likes, this.isLiked);
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [const BoxShadow(spreadRadius: 1.0, blurRadius: 2.0, color: Colors.black12)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            postLeft(context),
            postRight(context),
          ],
        )
    );
  }

  String formatTime(var postTime) {
    num duration = (DateTime.now().millisecondsSinceEpoch / 1000).floor() - postTime;
    if (duration < 60) {
      // 60 seconds
      return "$duration seconds ago";
    } else if (duration < 60 * 60) {
      // 1 hour
      return "${(duration/60).floor()} minutes ago";
    } else if (duration < 60 * 60 * 24) {
      // 1 day
      return "${(duration/60/60).floor()} hours ago";
    } else if (duration < 60 * 60 * 24 * 7) {
      // 1 week
      return "${(duration/60/60/24).floor()} days ago";
    } else {
      // Return day
      return "${DateTime.fromMillisecondsSinceEpoch(postTime * 1000)}";
    }
  }

  Widget postLeft(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              foregroundImage: badges.containsKey(widget.badge) ? badges[widget.badge]!.assetImage : null,
              radius: 25.0,
              backgroundColor: Theme.of(context).colorScheme.primary,
            )
        ),
        IconButton(
          icon: widget.likeInfo.isLiked ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary) : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary),
          iconSize: 30.0,
          onPressed: () {
            setState(() {
              widget.likeInfo.isLiked = !widget.likeInfo.isLiked;
              if (widget.likeInfo.isLiked) {
                Data.likePost(widget.postId, widget.username);
              } else {
                Data.unlikePost(widget.postId, widget.username);
              }
            });
          },
        ),
        Text(
          widget.likeInfo.likes.toString(),
        ),
        /*IconButton(
          icon: Icon(
            Icons.share_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            // TODO: Share with others
          },
        )*/
      ],
    );
  }

  Widget postRight(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            // Header
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.username,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                formatTime(widget.time),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [BoxShadow(spreadRadius: 1.0, blurRadius: 2.0, color: Colors.black12)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            widget.caption,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            constraints: const BoxConstraints(maxHeight: 30.0),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.filters.length,
              separatorBuilder: (BuildContext context, int index) => const VerticalDivider(thickness: 0, width: 10.0),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 30.0, right: 30.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                        widget.filters[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
