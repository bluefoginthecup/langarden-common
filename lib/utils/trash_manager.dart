import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TrashManager {
  /// 여러 아이템을 휴지통으로 이동하는 함수
  /// [showConfirmation]을 true로 하면 함수 내부에서 확인 다이얼로그를 표시합니다.
  static Future<void> moveItemsToTrash({
    required BuildContext context,
    required List<String> docIds,
    required String originalCollection,
    required String trashCollection,
    required String itemType,
    bool showConfirmation = true,
  }) async {
    if (showConfirmation) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("휴지통으로 이동 확인"),
          content: const Text("선택한 항목을 휴지통으로 보내시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("확인"),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

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
