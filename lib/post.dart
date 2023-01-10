import 'package:flutter/material.dart';
import 'dart:ui';

class Post extends StatefulWidget {
  final String badge;
  final String username;
  final int time;
  final String content;
  final List<FilterInfo> filters;
  final LikeInfo likeInfo;

  const Post({Key? key,
    required this.badge,
    required this.username,
    required this.time,
    required this.content,
    required this.filters,
    required this.likeInfo,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}
class FilterInfo {
  String label;
  bool isSelected = false;

  FilterInfo(this.label);
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
        boxShadow: [BoxShadow(spreadRadius: 1.0, blurRadius: 2.0, color: Colors.black12)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          postLeft(context),
          postRight(context),
        ],
      )
    );
  }

  Widget postLeft(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25.0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            // TODO: Load badge based off of id given
          )
        ),
        IconButton(
          icon: widget.likeInfo.isLiked ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary) : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary),
          iconSize: 30.0,
          onPressed: () {
            setState(() {
              widget.likeInfo.isLiked = !widget.likeInfo.isLiked;
              // TODO: Save like status to database
            });
          },
        ),
        Text(
          widget.likeInfo.likes.toString(),
        ),
        IconButton(
          icon: Icon(
            Icons.share_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            // TODO: Share with others
          },
        )
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
                // TODO: Display time since last post if made < 1 day ago, else display time/date
                widget.time.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          Text(
            widget.content,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}