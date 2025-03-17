import 'package:flutter/material.dart';
import 'package:langarden_common/utils/tooltip_messages.dart'; // ✅ 툴팁 메시지 불러오기

/// ✅ Flutter 기본 `IconButton`과 충돌하지 않도록 `AppIconButton`으로 이름 변경
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const AppIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

      Tooltip(
      message: tooltipMessages[icon] ?? "알 수 없는 기능", // ✅ 툴팁 자동 적용
      child: IconButton(
        icon: Icon(icon, size: 40),
        onPressed: onPressed,
      ),
    );
  }
}
