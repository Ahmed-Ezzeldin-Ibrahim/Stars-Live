// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FireBaseFireStoreHelper{

//   static Future<bool> addToCollection({@required String tableName,
//     @required Map<String,dynamic> data})async{
//     await FirebaseFirestore.instance.collection(tableName).add(data);
//     return true;
//   }

//   static Future addToCollectionWithId({@required String tableName,@required String id,
//     @required Map<String,dynamic> data})async{
//     await FirebaseFirestore.instance.collection(tableName).doc(id).set(data);
//   }

//   static Future<List<Map<String,dynamic>> > getTableData(String tableName)async{
//     QuerySnapshot data = await FirebaseFirestore.instance.collection(tableName).get();
//     List<Map<String,dynamic>> result = data.docs.map((e) => e.data()).toList();
//     return result;
//   }

//   static Stream<QuerySnapshot> getTableDataStream(String tableName){
//     return FirebaseFirestore.instance.collection(tableName).snapshots();
//   }

//   static Future<Map<String,dynamic>> getItemById(String tableName,String id)async{
//     print("getItemBy  Id  ${tableName}");
//     print("getItemBy  Id  ${id}");
//     DocumentSnapshot result = await FirebaseFirestore.instance.collection(tableName).doc(id).get();
//     print("getItem  ${result.id}");
//     print("getItem  ${result.data()}");
//     if(result.exists) return result.data();
//     else return null;
//   }

//   static Future<List> getItemChatWithById(String tableName,String id)async{
//     print("getItemBy  Id  ${tableName}");
//     print("getItemBy  Id  ${id}");
//     DocumentSnapshot result = await FirebaseFirestore.instance.collection(tableName).doc(id).get();
//     print("getItem  ${result.id}");
//     print("getItem  ${result.data()}");
//     if(result.exists) return result['chattingWith'];
//     else return null;
//   }

//   static Future<bool> updateItemById({@required String tableName,@required String id,
//     @required Map<String,dynamic> data})async{
//     FirebaseFirestore.instance.collection(tableName).doc(id).update(data);
//     return true;
//   }

//   static Future<bool> detectIsItemFound({@required String tableName,@required String userId}) async{
//     DocumentSnapshot res = await FirebaseFirestore.instance.collection(tableName).doc(userId).get();
//     return res.exists;
//   }



// }