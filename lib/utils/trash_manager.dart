import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrashManager {
  /// 여러 아이템을 휴지통에서 복원
  static Future<void> restoreItems({
    required BuildContext context,
    required List<String> docIds,
    required String trashCollection, // 예: 'trash'
    required String originalCollection, // 예: 'verbs' or 'flashcard_sets'
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var docId in docIds) {
        final trashDocRef = FirebaseFirestore.instance
            .collection(trashCollection)
            .doc(docId);

        final trashDocSnapshot = await trashDocRef.get();
        if (!trashDocSnapshot.exists) continue;
        final trashData = trashDocSnapshot.data() as Map<String, dynamic>;

        final originalId = trashData["originalId"];
        final originalRef = FirebaseFirestore.instance
            .collection(originalCollection)
            .doc(originalId);

        final data = trashData["data"];
        batch.set(originalRef, data);
        batch.delete(trashDocRef);
      }

      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("복원되었습니다.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("복원 실패: $e")),
      );
    }
  }

  /// 여러 아이템을 휴지통으로 이동
  static Future<void> moveItemsToTrash({
    required BuildContext context,
    required List<String> docIds,
    required String originalCollection,
    required String trashCollection,
    required String itemType,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var docId in docIds) {
        final originalRef = FirebaseFirestore.instance
            .collection(originalCollection)
            .doc(docId);

        final docSnapshot = await originalRef.get();
        if (!docSnapshot.exists) continue;
        final data = docSnapshot.data() as Map<String, dynamic>;

        final trashData = {
          "type": itemType,
          "originalId": docId,
          "data": data,
          "deletedAt": FieldValue.serverTimestamp(),
        };
        final trashDocRef = FirebaseFirestore.instance
            .collection(trashCollection)
            .doc(docId);

        batch.set(trashDocRef, trashData);
        batch.delete(originalRef);
      }

      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("휴지통으로 이동되었습니다.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("휴지통 이동 실패: $e")),
      );
    }
  }

/// 필요하다면 휴지통 완전 삭제 함수도 만들 수 있음
}
