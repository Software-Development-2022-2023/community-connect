import 'dart:io';

import 'package:community_connect/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_connect/util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'badge.dart';

class Data {
  static final posts = FirebaseFirestore.instance.collection("posts");
  static final users = FirebaseFirestore.instance.collection("users");
  static final storage = FirebaseStorage.instance;

  static uploadPost(String userId, String content, File imgFile, List<String> subjects) async {
    if (userId == '') {
      var temp = await getUsername();
      if (temp == null) {
        return;
      }

      userId = temp;
    }

    final res = posts.doc();
    await res.set({
      "docID": res.id,
      "user": userId,
      "content": content,
      "time": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      "likes": 0,
      "subjects": subjects,
    });

    final userRes = await users.doc(userId).update({'posts': FieldValue.arrayUnion([res.id])});

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

    /*for (String k in subjects) {
      order = order.where(k, isEqualTo: true);
    }*/

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
          final ref = storage.ref();
          imgUrl = await ref
              .child(doc['docID'])
              .getDownloadURL();
        } catch(e, _) {}

        final userData = await getUserData(doc['user']);
        final personalData = await getUserData('');
        if (userData.isNotEmpty && imgUrl != null) {
            res.add(Post(
              badge: userData['equippedBadge'],
              username: doc['user'],
              time: doc['time'],
              caption: doc['content'],
              filters: filters,
              likeInfo: LikeInfo(doc['likes'], personalData['likedPosts'].contains(doc['docID'])),
              imageUrl: imgUrl,
              postId: doc['docID'],
            ));
          }
        }
      }

    return res;
  }

  static Future<String> getDownloadUrl(String postId) async {
    final ref = storage.ref();
    final imgRef = ref.child(postId);
    return imgRef.getDownloadURL();
  }

  static Future<List<List<dynamic>>> getOrderedUsers() async {
    final ordered = users.orderBy('followers');
    List<List<dynamic>> res = [];
    QuerySnapshot snapshot = await ordered.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      if (doc.exists) {
        res.add([doc['equippedBadge'], doc['username'], doc['followers']]);
      }
    }

    return res;
  }

  static Future<Map<String, dynamic>> getUserData(String username) async {
    if (username == '') {
      final user = await getUsername();
      if (user == null) return {};
      username = user;
    }
    DocumentSnapshot userData = await users.doc(username).get();

    if (!userData.exists) {
      return {};
    }

    return userData.data() as Map<String, dynamic>;
  }


  static Future<bool> createAccount(String username) async {
    if ((await Data.getUserData(username)).isNotEmpty) {
      return false;
    }

    final res = users.doc(username);
    await res.set({'username': username,
      'badges': [],
      'treecoins': 2343,
      'likedPosts': [],
      'joinDate': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      'equippedBadge': '',
      'followedAccounts': [],
      'followers': 0,
      'posts': [],
      'likes': 0,
    });

    return true;
  }

  static Future<bool> buyBadge(BadgeInfo badgeInfo) async {
    final uData = await Data.getUserData('');
    if (uData.isEmpty || uData['treecoins'] < badgeInfo.cost || uData['badges'].contains(badgeInfo.id)) {
      return false;
    }

    users.doc(uData['username']).update({'treecoins': FieldValue.increment(-badgeInfo.cost), 'badges': FieldValue.arrayUnion([badgeInfo.id])});
  return true;
  }

  static Future<void> equipBadge(BadgeInfo badgeInfo) async {
    final uData = await Data.getUserData('');
    if (uData.isEmpty || !uData['badges'].contains(badgeInfo.id)) {
      return;
    }

    users.doc(uData['username']).update({'equippedBadge': badgeInfo.id});
  }

  static Future<void> likePost(String postId, String targetUser) async {
    final uData = await Data.getUserData('');
    final targetUData = await Data.getUserData(targetUser);
    if (uData.isEmpty || targetUData.isEmpty || uData['likedPosts'].contains(postId)) {
      return;
    }

    users.doc(uData['username']).update({'likedPosts': FieldValue.arrayUnion([postId])});
    users.doc(targetUser).update({'likes': FieldValue.increment(1)});
    posts.doc(postId).update({'likes': FieldValue.increment(1)});
  }

  static Future<void> unlikePost(String postId, String targetUser) async {
    final uData = await Data.getUserData('');
    final targetUData = await Data.getUserData(targetUser);
    if (uData.isEmpty || targetUData.isEmpty || !uData['likedPosts'].contains(postId)) {
      return;
    }

    users.doc(uData['username']).update({'likedPosts': FieldValue.arrayRemove([postId])});
    users.doc(targetUser).update({'likes': FieldValue.increment(-1)});
    posts.doc(postId).update({'likes': FieldValue.increment(-1)});
  }
}