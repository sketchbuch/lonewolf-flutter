import 'package:flutter/material.dart';

import '../models/content/combat_tag.dart';
import 'content_renderer.dart';

class Combat extends StatelessWidget with ContentRenderer {
  final CombatTag tag;

  const Combat(this.tag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wrapContent(
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            WidgetSpan(
              child: Padding(padding: const EdgeInsets.only(right: 8.0), child: Text('${tag.enemy}:')),
            ),
            WidgetSpan(
              child: Padding(padding: const EdgeInsets.only(right: 8.0), child: Text('Combat Skill'.toUpperCase())),
            ),
            WidgetSpan(
              child: Padding(padding: const EdgeInsets.only(right: 16.0), child: Text(tag.combatskill.toString())),
            ),
            WidgetSpan(
              child: Padding(padding: const EdgeInsets.only(right: 8.0), child: Text('Endurance'.toUpperCase())),
            ),
            TextSpan(text: tag.endurance.toString()),
          ],
        ),
      ),
    );
  }
}
