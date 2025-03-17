import 'package:flutter/material.dart';

class FlashcardFilter extends StatefulWidget {
  final Set<String> selectedPersons;
  final Set<String> selectedTenses;
  final Set<String> selectedExamples;
  final Function(Set<String>, Set<String>, Set<String>) onFilterChanged;

  const FlashcardFilter({
    Key? key,
    required this.selectedPersons,
    required this.selectedTenses,
    required this.selectedExamples,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  _FlashcardFilterState createState() => _FlashcardFilterState();
}

class _FlashcardFilterState extends State<FlashcardFilter> {
  late Set<String> _persons;
  late Set<String> _tenses;
  late Set<String> _examples;

  final List<String> _personOptions = ["yo", "tú", "él/ella", "nosotros", "vosotros", "ellos"];
  final List<String> _tenseOptions = ["present", "preterite", "imperfect", "future", "subjunctive_present", "subjunctive_past", "imperative"];
  final List<String> _exampleOptions = ["beginner", "intermediate", "advanced"];

  @override
  void initState() {
    super.initState();
    _persons = Set.from(widget.selectedPersons);
    _tenses = Set.from(widget.selectedTenses);
    _examples = Set.from(widget.selectedExamples);
  }

  void _applyFilters() {
    widget.onFilterChanged(_persons, _tenses, _examples);
    Navigator.pop(context); // ✅ 필터 적용 후 닫기
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // ✅ 화면 높이의 60%만 사용
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("🔎 필터 설정", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Divider(),

          Expanded(
            child: SingleChildScrollView( // ✅ 스크롤 가능하게 변경
              child: Column(
                children: [
                  // 인칭 필터
                  const Text("💡 학습할 인칭 선택", style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    children: _personOptions.map((person) => ChoiceChip(
                      label: Text(person),
                      selected: _persons.contains(person),
                      onSelected: (selected) {
                        setState(() {
                          selected ? _persons.add(person) : _persons.remove(person);
                        });
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: 10),

                  // 시제 필터
                  const Text("💡 학습할 시제 선택", style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    children: _tenseOptions.map((tense) => ChoiceChip(
                      label: Text(tense),
                      selected: _tenses.contains(tense),
                      onSelected: (selected) {
                        setState(() {
                          selected ? _tenses.add(tense) : _tenses.remove(tense);
                        });
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: 10),

                  // 예문 필터
                  const Text("💡 학습할 예문 선택", style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    children: _exampleOptions.map((example) => ChoiceChip(
                      label: Text(example),
                      selected: _examples.contains(example),
                      onSelected: (selected) {
                        setState(() {
                          selected ? _examples.add(example) : _examples.remove(example);
                        });
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // ✅ 적용 버튼 (화면 아래 고정)
          ElevatedButton(
            onPressed: _applyFilters,
            child: const Text("필터 적용"),
          ),
        ],
      ),
    );
  }
}
