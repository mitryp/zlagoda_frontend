import 'dart:convert';

import 'package:http/http.dart' show Response;

/// Decodes JSON body of the given response.
///
dynamic decodeResponseBody(Response res) => jsonDecode(utf8.decode(res.bodyBytes));