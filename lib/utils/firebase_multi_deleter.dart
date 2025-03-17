// lib/utils/firebase_multi_deleter.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMultiDeleter {
  /// 범용 멀티 삭제 함수
  static Future<void> deleteItems({
    required BuildContext context,
    required List<String> itemIds,
    required CollectionReference collectionRef,
    String confirmTitle = "삭제 확인",
    String confirmContent = "선택한 항목을 삭제하시겠습니까?",
    String successMessage = "삭제되었습니다.",
  }) async {
    if (itemIds.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(confirmTitle),
        content: Text("$confirmContent (${itemIds.length}개)"),
        actions: [
          TextButton(
            child: const Text("취소"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("삭제"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var id in itemIds) {
        final ref = collectionRef.doc(id);
        batch.delete(ref);
      }
      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("삭제 실패: $e")),
      );
    }
  }
}
