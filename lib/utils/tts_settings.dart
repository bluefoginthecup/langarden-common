class TTSSettings {
  double ttsSpeed;
  int repeatCount;
  String readingMode;
  String frontLanguage;
  String backLanguage;
  double fontSize;
  int timerMinutes;
  bool shuffleEnabled;

  TTSSettings({
    required this.ttsSpeed,
    required this.repeatCount,
    required this.readingMode,
    required this.frontLanguage,
    required this.backLanguage,
    required this.fontSize,
    required this.timerMinutes,
    required this.shuffleEnabled,
  });

  factory TTSSettings.defaultSettings() => TTSSettings(
    ttsSpeed: 0.5,
    repeatCount: 1,
    readingMode: '앞뒤',
    frontLanguage: 'es-ES',
    backLanguage: 'ko-KR',
    fontSize: 28.0,
    timerMinutes: 0,
    shuffleEnabled: false,
  );

  Map<String, dynamic> toMap() => {
    'ttsSpeed': ttsSpeed,
    'repeatCount': repeatCount,
    'readingMode': readingMode,
    'frontLanguage': frontLanguage,
    'backLanguage': backLanguage,
    'fontSize': fontSize,
    'timerMinutes': timerMinutes,
    'shuffleEnabled': shuffleEnabled,
  };

  static TTSSettings fromMap(Map<String, dynamic> map) => TTSSettings(
    ttsSpeed: (map['ttsSpeed'] ?? 0.5).toDouble(),
    repeatCount: map['repeatCount'] ?? 1,
    readingMode: map['readingMode'] ?? '앞뒤',
    frontLanguage: map['frontLanguage'] ?? 'es-ES',
    backLanguage: map['backLanguage'] ?? 'ko-KR',
    fontSize: (map['fontSize'] ?? 28.0).toDouble(),
    timerMinutes: map['timerMinutes'] ?? 0,
    shuffleEnabled: map['shuffleEnabled'] ?? false,
  );
}
