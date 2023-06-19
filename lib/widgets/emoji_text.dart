import 'package:flutter/material.dart';

class EmojiText extends StatelessWidget {

  const EmojiText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildText(text),
      textAlign: TextAlign.center,
    );
  }

  TextSpan _buildText(String text) {
    final children = <TextSpan>[]; 
    final runes = text.runes;

    for (int i = 0; i < runes.length; /* empty */ ) {
      int current = runes.elementAt(i);

      final isEmoji = current > 255;
      final shouldBreak = isEmoji
        ? (x) => x <= 255 
        : (x) => x > 255;

      final chunk = <int>[];
      while (! shouldBreak(current)) {
        chunk.add(current);
        if (++i >= runes.length) break;
        current = runes.elementAt(i);
      }

      children.add(
        TextSpan(
          text: String.fromCharCodes(chunk),
          style: TextStyle(
            fontFamily: isEmoji ? 'EmojiOne' : null,
          ),
        ),
      );
    }

    return TextSpan(children: children);
  } 
} 
