import 'package:flutter/material.dart';

class TTSControls extends StatefulWidget {
  final VoidCallback onToggleTTS;
  final ValueChanged<String> onChangeReadingMode;
  final ValueChanged<double> onChangeSpeed;
  final ValueChanged<int> onChangeRepeat;
  final ValueChanged<bool> onToggleShuffle;
  final ValueChanged<int> onChangeTimer;
  final ValueChanged<int> onCardSliderChanged;
  final ValueChanged<String> onChangeFrontLanguage;
  final ValueChanged<String> onChangeBackLanguage;
  final ValueChanged<double> onFontSizeChanged;
  final int currentCardIndex;
  final int totalCards;
  final bool isPlaying;
  final bool isPaused;
  final String frontLanguage;
  final String backLanguage;

  const TTSControls({
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
    required this.onFontSizeChanged,
    required this.currentCardIndex,
    required this.totalCards,
    required this.isPlaying,
    required this.isPaused,
    required this.frontLanguage,
    required this.backLanguage,
  }) : super(key: key);

  @override
  _TTSControlsState createState() => _TTSControlsState();
}

class _TTSControlsState extends State<TTSControls> {
  bool isExpanded = false;

  String readingMode = "앞뒤";
  double ttsSpeed = 0.5;
  int repeatCount = 1;
  bool shuffleEnabled = false;
  int timerMinutes = 0;
  double fontSize = 28.0;
  final double minFontSize = 28.0;
  final double maxFontSize = 60.0;


  final Map<String, String> languageOptions = {
    "English": "en-US",
    "Spanish": "es-ES",
    "Korean": "ko-KR",
    "French": "fr-FR",
    "German": "de-DE",
  };

  late String selectedFrontLanguage;
  late String selectedBackLanguage;

  @override
  void initState() {
    super.initState();
    selectedFrontLanguage = widget.frontLanguage;
    selectedBackLanguage = widget.backLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        children: [
          // 더보기/접기 토글 버튼
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              label: Text(isExpanded ? "접기" : "더 보기"),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),

          // 확장 가능한 영역
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                // 읽기 모드, 속도
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: readingMode,
                      items: ["앞뒤", "뒤앞", "앞면만", "뒷면만"]
                          .map((v) => DropdownMenuItem<String>(
                        value: v,
                        child: Text(v),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => readingMode = value);
                          widget.onChangeReadingMode(value);
                        }
                      },
                    ),
                    const Text("TTS 속도"),
                    Slider(
                      value: ttsSpeed,
                      min: 0.3,
                      max: 1.0,
                      divisions: 7,
                      label: "${ttsSpeed.toStringAsFixed(1)}x",
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: onSurface.withAlpha(77),
                      onChanged: (value) {
                        setState(() => ttsSpeed = value);
                        widget.onChangeSpeed(value);
                      },
                    ),
                  ],
                ),

                // 반복, 셔플, 타이머
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<int>(
                      value: repeatCount,
                      items: List.generate(10, (i) => i + 1)
                          .map((v) => DropdownMenuItem<int>(
                        value: v,
                        child: Text("반복 $v 회"),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => repeatCount = value);
                          widget.onChangeRepeat(value);
                        }
                      },
                    ),
                    Switch(
                      value: shuffleEnabled,
                      onChanged: (value) {
                        setState(() => shuffleEnabled = value);
                        widget.onToggleShuffle(value);
                      },
                    ),
                    const Text("셔플"),
                    DropdownButton<int>(
                      value: timerMinutes,
                      items: [0, 5, 10, 15, 30, 60, 120, 300]
                          .map((v) => DropdownMenuItem<int>(
                        value: v,
                        child: Text(v == 0 ? "타이머 없음" : "$v 분"),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => timerMinutes = value);
                          widget.onChangeTimer(value);
                        }
                      },
                    ),
                  ],
                ),

// 🔧 카드 글자 크기 + 앞/뒷면 언어 설정을 하나의 Row에 묶되, 구조를 명확히 분리
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // 카드 글자 크기
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text("카드 글자 크기"),
    Row(
    children: [
    IconButton(
    icon: const Icon(Icons.remove),
    onPressed: fontSize > minFontSize
    ? () {
    setState(() {
    fontSize -= 2;
    widget.onFontSizeChanged(fontSize);
    });
    }
        : null,
    ),
    Text("${fontSize.toInt()}pt"),
    IconButton(
    icon: const Icon(Icons.add),
    onPressed: fontSize < maxFontSize
    ? () {
    setState(() {
    fontSize += 2;
    widget.onFontSizeChanged(fontSize);
    });
    }
        : null,
    ),
    ],
    ),
    ],
    ),

    // 앞면 언어 선택
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text("앞면 언어"),
    DropdownButton<String>(
    value: selectedFrontLanguage,
    items: languageOptions.entries
        .map((e) => DropdownMenuItem<String>(
    value: e.value,
    child: Text(e.key),
    ))
        .toList(),
    onChanged: (value) {
    if (value != null) {
    setState(() => selectedFrontLanguage = value);
    widget.onChangeFrontLanguage(value);
    }
    },
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
        .map((e) => DropdownMenuItem<String>(
    value: e.value,
    child: Text(e.key),
    ))
        .toList(),
    onChanged: (value) {
    if (value != null) {
    setState(() => selectedBackLanguage = value);
    widget.onChangeBackLanguage(value);
    }
    },
    ),
    ],
    ),
    ],
    ),

                const SizedBox(height: 10),




          const SizedBox(height: 10),

          // 항상 보이는 재생 버튼
          IconButton(
            iconSize: 48,
            icon: Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow),
            color: onSurface,
            onPressed: widget.onToggleTTS,
          ),

          const SizedBox(height: 10),

          // 항상 보이는 카드 슬라이더
          Column(
            children: [
              Slider(
                value: widget.currentCardIndex.toDouble(),
                min: 0,
                max: widget.totalCards > 0
                    ? (widget.totalCards - 1).toDouble()
                    : 0,
                activeColor: theme.colorScheme.primary,
                inactiveColor: onSurface.withAlpha(77),
                onChanged: (value) {
                  widget.onCardSliderChanged(value.toInt());
                },
              ),
              Text("카드 ${widget.currentCardIndex + 1} / ${widget.totalCards}"),
            ],
          ),
        ],
      ),
            secondChild: const SizedBox.shrink(),
    )
        ]
    )
    );

  }
}
