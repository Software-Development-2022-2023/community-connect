import 'dart:io';

import 'package:community_connect/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Data {
  static final posts = FirebaseFirestore.instance.collection("posts");
  static final storage = FirebaseStorage.instance;

  static uploadPost(String userId, String content, File imgFile, List<String> subjects) async {
    final res = posts.doc();
    await res.set({
      "docID": res.id,
      "user": userId,
      "content": content,
      "time": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      "likes": 0,
      "subjects": subjects,
    });

    try {
      final imgRef = storage.ref().child(res.id!);
      await imgRef.putFile(imgFile);
    } catch (e) {
      print("Unable to upload image.");
      return;
    }
  }

  static Future<List<Post>> getPosts({required String sortBy, required List<String> subjects, searchTerm}) async {
    var order;
    if (sortBy == "Most recent") {
      order = posts.orderBy('time', descending: true);
    } else if (sortBy == "Most liked") {
      order = posts.orderBy('likes', descending: true);
    } else if (sortBy == "Least liked") {
      order = posts.orderBy('likes', descending: false);
    } else if (sortBy == "Oldest") {
      order = posts.orderBy('time', descending: false);
    }

    List<Post> res = [];
    QuerySnapshot snapshot = await order.get();
    for (var doc in snapshot.docs) {
      if (doc.exists) {
        List<String> filters = [];
        doc['subjects'].forEach((var filter) {
          filters.add(filter.toString());
        });

        String? imgUrl;
        try {
          imgUrl = await storage.ref()
              .child(doc['docID'])
              .getDownloadURL();
        } catch(e) {

        }

        if (imgUrl != null) {
            res.add(Post(
              badge: "",
              username: doc['user'],
              time: doc['time'],
              caption: doc['content'],
              filters: filters,
              likeInfo: LikeInfo(doc['likes'], false),
              imageUrl: imgUrl,
            ));
          }
        }
      }

    return res;
  }
}