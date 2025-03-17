import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultiSelectController extends StateNotifier<Set<String>> {
  MultiSelectController() : super({});

  bool selectionMode = false;

  void toggleSelectionMode() {
    selectionMode = !selectionMode;
    if (!selectionMode) state = {};
  }

  void toggleItem(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void clearSelection() {
    state = {};
  }

  bool isSelected(String id) => state.contains(id);
}

final multiSelectControllerProvider =
StateNotifierProvider<MultiSelectController, Set<String>>(
      (_) => MultiSelectController(),
);
