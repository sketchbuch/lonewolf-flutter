import 'package:flutter/material.dart';

import '../../models/book/content/choice_tag.dart';
import '../content.dart';
import '../content_renderer.dart';

class Choice extends StatelessWidget with ContentRenderer {
  final ChoiceTag tag;

  const Choice(this.tag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int textIndex = -1;

    return Content(
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: tag.texts.map((text) {
            textIndex += 1;

            final style = getTextElementStyle(text);
            var weight = getTextElementWeight(text);

            if (tag.linkTextIndex == textIndex) {
              weight = FontWeight.bold;
            }

            return TextSpan(text: text.text, style: TextStyle(fontWeight: weight, fontStyle: style));
          }).toList(),
        ),
      ),
    );
  }
}
