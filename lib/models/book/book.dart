import 'package:lonewolf_new/models/book/helpers/section_cache.dart';
import 'package:xml/xml.dart';

import '../../exceptions/xml.dart';
import '../../types/types.dart';
import '../../utils/xml/helpers.dart';
import 'content/plain_list_tag.dart';
import 'content/section_tag.dart';
import 'meta/meta.dart';
import 'toc/toc_index_section.dart';

class Book {
  final _sectionCache = SectionCache();
  final List<SectionTag> sections = [];
  late PlainListTag toc;
  late BookText title = '';
  late Meta meta;
  late String lang = '';
  late String version = '';

  // ignore: unused_element
  Book._();

  Book.fromXml(XmlElement xml) {
    lang = getAttribute('xml:lang', xml);
    version = getAttribute('version', xml);

    final metaXml = xml.getElement('meta');

    if (metaXml != null) {
      meta = Meta.fromXml(metaXml);
      title = meta.title;
    }

    final titleSection = _getTitleSection(xml);
    final titleSubsections = _getTitleSubsections(titleSection);
    final numberedSection = _getNumberedSection(titleSubsections);
    final numberedBaseData = _getNumberedData(numberedSection);

    final frontmatter = titleSubsections
        .where((sec) {
          final className = sec.getAttribute('class');
          return className == SectionType.frontmatter.name;
        })
        .map((xml) => SectionTag.fromXml(xml))
        .toList();

    frontmatter.insert(0, SectionTag.fromXml(titleSection, addSubsections: false, forcedType: SectionType.frontmatter));
    frontmatter.add(SectionTag.fromXml(numberedSection, addSubsections: false, forcedType: SectionType.frontmatter));

    final numbered = numberedBaseData.findElements('section').map((xml) => SectionTag.fromXml(xml)).toList();

    final backmatter = titleSubsections
        .where((sec) => sec.getAttribute('class') == SectionType.backmatter.name)
        .map((xml) => SectionTag.fromXml(xml))
        .toList();

    sections.addAll(frontmatter);
    sections.addAll(numbered);
    sections.addAll(backmatter);

    toc = _buildToc();
  }

// TODO - Add bookIndex
  Json toJson() => {
        'lang': lang,
        'meta': meta.toJson(),
        'sections': sections.map((section) => section.toJson()).toList(),
        'title': title,
        'version': version,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  PlainListTag _buildToc() {
    final TocIndexSections tocIndexSections = [];

    for (var section in sections) {
      if (section.canAddToIndex()) {
        tocIndexSections.add(TocIndexSection(section, 1));

        if (section.isFrontmatter() && section.hasSubsections()) {
          final List<SectionTag> subsections = section.getSubsections();

          for (var subsection in subsections) {
            if (subsection.canAddToIndex(true)) {
              tocIndexSections.add(TocIndexSection(subsection, 2));
            }
          }
        }
      }
    }

    return PlainListTag.fromTocIndexSections(tocIndexSections);
  }

  Iterable<XmlElement> _getTitleSubsections(XmlElement titleSection) {
    final titleData = titleSection.getElement('data');

    if (titleData == null) {
      throw BookXmlException("Title section's data not found");
    }

    return titleData.findElements('section');
  }

  XmlElement _getNumberedSection(Iterable<XmlElement> titleSubsections) {
    final numberedBaseSection = titleSubsections.where((sec) =>
        sec.getAttribute('class') == SectionType.numbered.name && sec.getAttribute('id') == SectionType.numbered.name);

    if (numberedBaseSection.isEmpty) {
      throw BookXmlException('Numbered base section not found');
    }

    return numberedBaseSection.first;
  }

  XmlElement _getNumberedData(XmlElement numberedSection) {
    final numberedBaseData = numberedSection.getElement('data');

    if (numberedBaseData == null) {
      throw BookXmlException('Numbered base data not found');
    }
    return numberedBaseData;
  }

  XmlElement _getTitleSection(XmlElement bookXml) {
    final baseSection = bookXml.findElements('section').where((element) => element.getAttribute('id') == 'title');

    if (baseSection.isEmpty) {
      throw BookXmlException('Title section not found');
    }

    return baseSection.first;
  }

  SectionTag? getSection(String sectionId) {
    // TODO - check cache is working
    if (_sectionCache.contains(sectionId)) {
      return _sectionCache.get(sectionId);
    }

    SectionTag? requiredSection;

    for (var section in sections) {
      if (requiredSection != null) {
        break;
      }

      if (section.id == sectionId) {
        requiredSection = section;
        break;
      } else if (section.hasSubsections()) {
        final List<SectionTag> subsections = section.getSubsections();

        for (var subsection in subsections) {
          if (subsection.id == sectionId) {
            requiredSection = subsection;
            break;
          }
        }
      }
    }

    if (requiredSection != null) {
      _sectionCache.set(sectionId, requiredSection);
      return requiredSection;
    }

    return null;
  }
}
