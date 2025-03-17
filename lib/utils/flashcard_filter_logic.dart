List<Map<String, String>> buildFilteredSubcardsFromVerb(
    Map<String, dynamic> docData,
    Set<String> selectedPersons,
    Set<String> selectedTenses,
    Set<String> selectedExamples) {

  List<Map<String, String>> subcards = [];

  // ✅ 1) 기본 카드 추가 (text ↔ meaning)
  final textValue = docData["text"] ?? "";
  final meaningValue = docData["meaning"] ?? "";
  if (textValue.isNotEmpty || meaningValue.isNotEmpty) {
    subcards.add({
      "text": textValue,
      "meaning": meaningValue,
    });
  }

  // ✅ 2) 시제별 변형 추가 (필터링 적용)
  final conj = docData["conjugations"] as Map<String, dynamic>?;
  if (conj != null) {
    selectedTenses.forEach((tense) {
      if (conj.containsKey(tense)) {
        final Map<String, dynamic> tenseMap = conj[tense];
        String filteredConjugations = _filterConjugations(tenseMap, selectedPersons);
        if (filteredConjugations.isNotEmpty) {
          subcards.add({
            "text": "$tense 시제",
            "meaning": filteredConjugations,
          });
        }
      }
    });
  }

  // ✅ 3) 예문 추가 (필터링 적용)
  final examples = docData["examples"] as Map<String, dynamic>?;
  if (examples != null) {
    selectedExamples.forEach((level) {
      if (examples.containsKey(level)) {
        subcards.add({
          "text": "예문($level)",
          "meaning": examples[level],
        });
      }
    });
  }

  return subcards;
}

/// 선택된 인칭(person)만 추출해서 문자열로 변환
String _filterConjugations(Map<String, dynamic> tenseMap, Set<String> selectedPersons) {
  List<String> parts = [];
  selectedPersons.forEach((person) {
    if (tenseMap.containsKey(person)) {
      parts.add("$person: ${tenseMap[person]}");
    }
  });
  return parts.join(", ");
}
