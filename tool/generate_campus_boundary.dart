import 'dart:convert';
import 'dart:io';

const _wayId = 254993254;

const _outputPath =
    'lib/features/campus_map/data/campus_boundary.dart';

Future<void> main() async {
  final client = HttpClient();

  try {
    final request = await client.getUrl(
      Uri.parse(
        'https://api.openstreetmap.org/api/0.6/way/$_wayId/full.json',
      ),
    );

    request.headers.set(
      HttpHeaders.userAgentHeader,
      'MEU-Mobile-Campus-Boundary-Generator/1.0',
    );

    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception(
        'OSM HTTP ${response.statusCode}',
      );
    }

    final body = await response
        .transform(utf8.decoder)
        .join();

    final json =
        jsonDecode(body) as Map<String, dynamic>;

    final elements =
        json['elements'] as List<dynamic>;

    final nodes =
        <int, ({double lat, double lon})>{};

    Map<String, dynamic>? way;

    for (final raw in elements) {
      final element =
          raw as Map<String, dynamic>;

      if (element['type'] == 'node') {
        nodes[element['id'] as int] = (
          lat: (element['lat'] as num)
              .toDouble(),
          lon: (element['lon'] as num)
              .toDouble(),
        );
      }

      if (element['type'] == 'way' &&
          element['id'] == _wayId) {
        way = element;
      }
    }

    if (way == null) {
      throw Exception(
        'Kampüs way bulunamadı.',
      );
    }

    final refs =
        (way['nodes'] as List<dynamic>)
            .cast<int>();

    final buffer = StringBuffer()
      ..writeln(
        "import 'package:google_maps_flutter/google_maps_flutter.dart';",
      )
      ..writeln()
      ..writeln(
        'const List<LatLng> campusBoundary = [',
      );

    var count = 0;

    for (final ref in refs) {
      final node = nodes[ref];

      if (node == null) {
        continue;
      }

      buffer.writeln(
        '  LatLng(${node.lat}, ${node.lon}),',
      );

      count++;
    }

    buffer.writeln('];');

    final output =
        File(_outputPath);

    await output.parent.create(
      recursive: true,
    );

    await output.writeAsString(
      buffer.toString(),
    );

    stdout.writeln(
      'Kampüs sınırı oluşturuldu: $count node',
    );

    stdout.writeln(
      _outputPath,
    );
  } finally {
    client.close();
  }
}
