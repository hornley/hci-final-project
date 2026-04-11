import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const MathText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        style ??
        TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14);

    final blockRegex = RegExp(r'\$\$([\s\S]*?)\$\$');
    final widgets = <Widget>[];
    var cursor = 0;

    for (final match in blockRegex.allMatches(text)) {
      final before = text.substring(cursor, match.start);
      if (before.trim().isNotEmpty) {
        widgets.add(_buildInlineMathText(before, effectiveStyle, textAlign));
      }

      final blockFormula = (match.group(1) ?? '').trim();
      if (blockFormula.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Math.tex(
                blockFormula,
                mathStyle: MathStyle.display,
                textStyle: effectiveStyle,
                onErrorFallback: (error) => Text(
                  blockFormula,
                  style: effectiveStyle,
                  textAlign: textAlign,
                ),
              ),
            ),
          ),
        );
      }
      cursor = match.end;
    }

    final tail = text.substring(cursor);
    if (tail.trim().isNotEmpty || widgets.isEmpty) {
      widgets.add(_buildInlineMathText(tail, effectiveStyle, textAlign));
    }

    return Column(
      crossAxisAlignment: _crossAxisForAlign(textAlign),
      children: widgets,
    );
  }

  Widget _buildInlineMathText(String source, TextStyle style, TextAlign align) {
    final inlineRegex = RegExp(r'\$([^\$]+)\$');
    final spans = <InlineSpan>[];
    var cursor = 0;

    for (final match in inlineRegex.allMatches(source)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: source.substring(cursor, match.start)));
      }

      final expression = (match.group(1) ?? '').trim();
      if (expression.isNotEmpty) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              expression,
              textStyle: style,
              onErrorFallback: (error) => Text(expression, style: style),
            ),
          ),
        );
      }
      cursor = match.end;
    }

    if (cursor < source.length) {
      spans.add(TextSpan(text: source.substring(cursor)));
    }

    return RichText(
      textAlign: align,
      text: TextSpan(style: style, children: spans),
    );
  }

  CrossAxisAlignment _crossAxisForAlign(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.right:
      case TextAlign.end:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }
}
