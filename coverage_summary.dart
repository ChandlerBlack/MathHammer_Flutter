#!/usr/bin/env dart
// Simple coverage summary generator
import 'dart:io';

void main() {
  final lcovFile = File('coverage/lcov.info');
  
  if (!lcovFile.existsSync()) {
    print('❌ No coverage file found. Run: flutter test --coverage');
    exit(1);
  }

  final lines = lcovFile.readAsLinesSync();
  final fileCoverage = <String, Map<String, int>>{};
  
  String? currentFile;
  int totalLines = 0;
  int coveredLines = 0;
  
  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
      fileCoverage[currentFile] = {'total': 0, 'covered': 0};
    } else if (line.startsWith('DA:') && currentFile != null) {
      final parts = line.substring(3).split(',');
      final hitCount = int.parse(parts[1]);
      
      fileCoverage[currentFile]!['total'] = 
        (fileCoverage[currentFile]!['total'] ?? 0) + 1;
      
      if (hitCount > 0) {
        fileCoverage[currentFile]!['covered'] = 
          (fileCoverage[currentFile]!['covered'] ?? 0) + 1;
      }
      
      totalLines++;
      if (hitCount > 0) coveredLines++;
    }
  }
  
  print('\n📊 Coverage Summary\n${'=' * 80}');
  
  final sortedFiles = fileCoverage.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  
  for (final entry in sortedFiles) {
    final file = entry.key.replaceAll('\\', '/');
    final total = entry.value['total']!;
    final covered = entry.value['covered']!;
    final percent = total > 0 ? (covered / total * 100).toStringAsFixed(1) : '0.0';
    
    String emoji;
    if (double.parse(percent) >= 80) {
      emoji = '✅';
    } else if (double.parse(percent) >= 50) {
      emoji = '⚠️ ';
    } else {
      emoji = '❌';
    }
    
    print('$emoji $percent%\t$covered/$total\t$file');
  }
  
  print('${'=' * 80}');
  final overallPercent = totalLines > 0 
    ? (coveredLines / totalLines * 100).toStringAsFixed(1) 
    : '0.0';
  print('🎯 Overall: $overallPercent% ($coveredLines/$totalLines lines covered)\n');
  
  if (double.parse(overallPercent) >= 80) {
    print('🎉 Great coverage!');
  } else if (double.parse(overallPercent) >= 50) {
    print('👍 Good start, but could use more tests');
  } else {
    print('⚡ Consider adding more tests');
  }
}
