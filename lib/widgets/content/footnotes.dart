import 'package:flutter/material.dart';
import 'package:lonewolf_new/theme/theme.dart';

import '../../../constants/typography.dart';
import '../../../models/book/section/footnote.dart';
import '../../../types/types.dart';
import '../../constants/layout.dart';
import '../layout/content_container.dart';
import '../layout/dividing_line.dart';
import '../mixins/content_renderer.dart';
import 'list/footnotes_list_item.dart';

class Footnotes extends StatelessWidget with ContentRenderer {
  final List<Footnote> footnotes;
  final OnNavigate onNavigate;

  const Footnotes(this.footnotes, this.onNavigate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: offsetLarge),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Footnotes',
                style: TextStyle(fontSize: fontSizeS, fontStyle: FontStyle.italic),
              ),
              SizedBox(width: offsetSmall),
              Expanded(
                  child: DividingLine(
                bottomPadding: sizeZero,
              )),
            ],
          ),
          ...footnotes.map((footnote) => FootnotesListItem(footnote, onNavigate, isInSection: true)).toList(),
        ],
      ),
    );
  }
}
