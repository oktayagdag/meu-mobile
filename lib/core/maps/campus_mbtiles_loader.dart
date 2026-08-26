import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CampusMbTilesLoader {
  CampusMbTilesLoader._();

  static const String _assetPath = 'assets/maps/meu_campus.mbtiles';

  // Haritayı ileride güncellersek v2, v3 diye artırırız.
  static const int _mapVersion = 3;

  static Future<String> load() async {
    final directory = await getApplicationSupportDirectory();

    final file = File('${directory.path}/meu_campus_v$_mapVersion.mbtiles');

    if (await file.exists()) {
      return file.path;
    }

    final ByteData data = await rootBundle.load(_assetPath);

    final Uint8List bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await file.writeAsBytes(bytes, flush: true);

    return file.path;
  }
}
