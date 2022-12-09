import '../section/section.dart';

class SectionCache {
  Map<String, Section> _cache = {};

  SectionCache();

  void deleteAll() {
    _cache = {};
  }

  void deleteOne(String key) {
    if (exists(key)) {
      _cache.remove(key);
    }
  }

  Section? get(String key) {
    return _cache[key];
  }

  bool exists(String key) {
    return _cache.containsKey(key);
  }

  void set(String key, Section section) {
    _cache[key] = section;
  }
}
