import 'package:flutter/material.dart';

class FlashcardControls extends StatefulWidget {
  final VoidCallback onToggleTTS;
  final ValueChanged<String> onChangeReadingMode;
  final ValueChanged<double> onChangeSpeed;
  final ValueChanged<int> onChangeRepeat;
  final ValueChanged<bool> onToggleShuffle;
  final ValueChanged<int> onChangeTimer;
  final ValueChanged<int> onCardSliderChanged;
  final ValueChanged<String> onChangeFrontLanguage;
  final ValueChanged<String> onChangeBackLanguage;

  final int currentCardIndex;
  final int totalCards;
  final bool isPlaying;
  final bool isPaused;

  final String frontLanguage;
  final String backLanguage;

  const FlashcardControls({
    Key? key,
    required this.onToggleTTS,
    required this.onChangeReadingMode,
    required this.onChangeSpeed,
    required this.onChangeRepeat,
    required this.onToggleShuffle,
    required this.onChangeTimer,
    required this.onCardSliderChanged,
    required this.onChangeFrontLanguage,
    required this.onChangeBackLanguage,
    required this.currentCardIndex,
    required this.totalCards,
    required this.isPlaying,
    required this.isPaused,
    required this.frontLanguage,
    required this.backLanguage,
  }) : super(key: key);

  @override
  _FlashcardControlsState createState() => _FlashcardControlsState();
}

class _FlashcardControlsState extends State<FlashcardControls> {
  String readingMode = "앞면만";
  double ttsSpeed = 0.5;
  int repeatCount = 1;
  bool shuffleEnabled = false;
  int timerMinutes = 0;

  // 선택 가능한 언어 목록 (표시 이름 -> TTS 언어 코드)
  final Map<String, String> languageOptions = {
    "English": "en-US",
    "Spanish": "es-ES",
    "Korean": "ko-KR",
    "French": "fr-FR",
    "German": "de-DE",
  };

  String selectedFrontLanguage = "es-ES";
  String selectedBackLanguage = "ko-KR";

  @override
  void initState() {
    super.initState();
    selectedFrontLanguage = widget.frontLanguage;
    selectedBackLanguage = widget.backLanguage;
  }

  void _onReadingModeChanged(String? value) {
    if (value != null) {
      setState(() {
        readingMode = value;
      });
      widget.onChangeReadingMode(value);
    }
  }

  void _onSpeedChanged(double value) {
    setState(() {
      ttsSpeed = value;
    });
    widget.onChangeSpeed(value);
  }

  void _onRepeatChanged(int? value) {
    if (value != null) {
      setState(() {
        repeatCount = value;
      });
      widget.onChangeRepeat(value);
    }
  }

  void _onShuffleToggled(bool value) {
    setState(() {
      shuffleEnabled = value;
    });
    widget.onToggleShuffle(value);
  }

  void _onTimerChanged(int? value) {
    if (value != null) {
      setState(() {
        timerMinutes = value;
      });
      widget.onChangeTimer(value);
    }
  }

  void _onFrontLanguageChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedFrontLanguage = newValue;
      });
      widget.onChangeFrontLanguage(newValue);
    }
  }

  void _onBackLanguageChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedBackLanguage = newValue;
      });
      widget.onChangeBackLanguage(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        children: [
          // 읽기 모드와 TTS 속도 조절
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: readingMode,
                items: ["앞면만", "뒷면만", "앞뒤 번갈아 읽기"]
                    .map((value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: _onReadingModeChanged,
              ),
              const Text("TTS 속도"),
              Slider(
                value: ttsSpeed,
                min: 0.3,
                max: 1.0,
                divisions: 7,
                label: "${ttsSpeed.toStringAsFixed(1)}x",
                onChanged: _onSpeedChanged,
              ),
            ],
          ),
          // 반복, 셔플, 타이머 조절
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<int>(
                value: repeatCount,
                items: List.generate(10, (index) => index + 1)
                    .map((value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text("반복 $value 회"),
                ))
                    .toList(),
                onChanged: _onRepeatChanged,
              ),
              Switch(
                value: shuffleEnabled,
                onChanged: _onShuffleToggled,
              ),
              const Text("셔플"),
              DropdownButton<int>(
                value: timerMinutes,
                items: [0, 5, 10, 15, 30, 60, 120, 300]
                    .map((value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text(value == 0 ? "타이머 없음" : "$value 분"),
                ))
                    .toList(),
                onChanged: _onTimerChanged,
              ),
            ],
          ),
          // 사용자 언어 선택 (앞면, 뒷면)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 앞면 언어 선택
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("앞면 언어"),
                  DropdownButton<String>(
                    value: selectedFrontLanguage,
                    items: languageOptions.entries
                        .map((entry) => DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    ))
                        .toList(),
                    onChanged: _onFrontLanguageChanged,
                  ),
                ],
              ),
              // 뒷면 언어 선택
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("뒷면 언어"),
                  DropdownButton<String>(
                    value: selectedBackLanguage,
                    items: languageOptions.entries
                        .map((entry) => DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    ))
                        .toList(),
                    onChanged: _onBackLanguageChanged,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 재생/일시정지 토글 버튼 (아이콘)
          IconButton(
            iconSize: 48,
            icon: Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: widget.onToggleTTS,
          ),
          const SizedBox(height: 10),
          // 카드 이동 슬라이더
          Column(
            children: [
              Slider(
                value: widget.currentCardIndex.toDouble(),
                min: 0,
                max: widget.totalCards > 0 ? (widget.totalCards - 1).toDouble() : 0,
                onChanged: (value) {
                  widget.onCardSliderChanged(value.toInt());
                },
              ),
              Text("카드 ${widget.currentCardIndex + 1} / ${widget.totalCards}"),
            ],
          ),
        ],
      ),
    );
  }
}
