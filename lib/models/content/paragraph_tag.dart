import 'package:xml/xml.dart';

import '../../types/types.dart';
import 'subcontent/text_element.dart';
import 'tag.dart';

class ParagraphTag extends Tag {
  late final List<TextElement> texts;

  ParagraphTag(this.texts);

  ParagraphTag.fromXml(XmlElement xml) {
    texts = [];

    var elementCount = 0;

    for (var index = 0; index < xml.children.length; index++) {
      final child = xml.children.elementAt(index);

      if (child.nodeType == XmlNodeType.ELEMENT) {
        final childElement = xml.childElements.elementAt(elementCount);
        texts.add(TextElement.fromXml(childElement));
        elementCount += 1;
      } else {
        texts.add(TextElement.fromTxt(child.text));
      }
    }
  }

  @override
  Json toJson() => {
        'texts': texts.map((text) => text.toJson()).toList(),
      };
}
