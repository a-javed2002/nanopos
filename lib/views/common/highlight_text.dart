import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle highlightStyle;
  final TextStyle textStyle;

  const HighlightedText({
    Key? key,
    required this.text,
    required this.query,
    this.highlightStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.yellow,
    ),
    this.textStyle = const TextStyle(
      fontSize: 10, fontWeight: FontWeight.bold
    ),
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: textStyle);
    }

    if (kDebugMode) {
      print("name is item $text & $query");
    }

    final escapedQuery = RegExp.escape(query);
    final regExp = RegExp(escapedQuery, caseSensitive: false);

    final matches = regExp.allMatches(text);
    final spans = <TextSpan>[];

    int currentPos = 0;
    for (final match in matches) {
      final matchedText = match[0]!;
      final start = match.start;
      final end = match.end;

      if (start > currentPos) {
        spans.add(TextSpan(text: text.substring(currentPos, start), style: textStyle));
      }

      spans.add(TextSpan(text: matchedText, style: highlightStyle));

      currentPos = end;
    }

    if (currentPos < text.length) {
      spans.add(TextSpan(text: text.substring(currentPos), style: textStyle));
    }

    return RichText(text: TextSpan(children: spans));
  }
}