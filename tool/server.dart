import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

const _upstream = 'https://raed-alkhair-api.onrender.com';

const _proxyPrefixes = <String>[
  '/api/',
  '/login',
  '/register',
  '/logout',
  '/cart',
  '/checkout',
  '/profile',
  '/products/',
  '/branches',
  '/orders/',
  '/static/',
];

bool _shouldProxy(String path) {
  for (final p in _proxyPrefixes) {
    if (path == p || path.startsWith(p)) return true;
  }
  return false;
}

Future<Response> _proxyHandler(Request request) async {
  final upstreamUri =
      Uri.parse('$_upstream${request.requestedUri.path}'
              '${request.requestedUri.query.isNotEmpty ? '?${request.requestedUri.query}' : ''}');

  final headers = <String, String>{};
  request.headers.forEach((k, v) {
    final lk = k.toLowerCase();
    if (lk == 'host' || lk == 'content-length') return;
    headers[k] = v;
  });

  final client = http.Client();
  try {
    final body = await request.read().fold<List<int>>(<int>[], (p, e) => p..addAll(e));
    final upstreamReq = http.Request(request.method, upstreamUri)
      ..headers.addAll(headers)
      ..followRedirects = false;
    if (body.isNotEmpty) upstreamReq.bodyBytes = body;

    final streamed = await client.send(upstreamReq);
    final respBytes = await streamed.stream.toBytes();

    final outHeaders = <String, List<String>>{};
    streamed.headers.forEach((k, v) {
      final lk = k.toLowerCase();
      if (lk == 'transfer-encoding' || lk == 'content-encoding' || lk == 'content-length') return;
      outHeaders.putIfAbsent(k, () => []).add(v);
    });

    final setCookie = streamed.headers['set-cookie'];
    if (setCookie != null) {
      outHeaders['set-cookie'] = [setCookie];
    }

    if (streamed.statusCode >= 300 && streamed.statusCode < 400) {
      final loc = streamed.headers['location'];
      if (loc != null) {
        final rewritten = loc.replaceFirst(_upstream, '');
        outHeaders['location'] = [rewritten];
      }
    }

    return Response(streamed.statusCode, body: respBytes, headers: outHeaders);
  } catch (e) {
    return Response.internalServerError(body: 'Proxy error: $e');
  } finally {
    client.close();
  }
}

void main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '5000') ?? 5000;
  final staticHandler = createStaticHandler('build/web', defaultDocument: 'index.html');

  Future<Response> handler(Request request) async {
    final path = '/${request.url.path}';
    if (_shouldProxy(path)) {
      return _proxyHandler(request);
    }
    return staticHandler(request);
  }

  final pipeline = const Pipeline().addMiddleware(logRequests()).addHandler(handler);
  final server = await shelf_io.serve(pipeline, '0.0.0.0', port);
  server.autoCompress = true;
  print('Serving on http://${server.address.host}:${server.port}');
  print('Proxying API calls to $_upstream');
}
