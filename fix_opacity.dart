import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print('lib directory not found.');
    return;
  }

  int count = 0;
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      final newContent = content.replaceAllMapped(
        RegExp(r'\.withOpacity\(\s*([^)]+)\s*\)'),
        (match) => '.withValues(alpha: ${match.group(1)})'
      );
      if (newContent != content) {
        entity.writeAsStringSync(newContent);
        print('Updated ${entity.path}');
        count++;
      }
    }
  }
  print('Updated $count files.');
}
