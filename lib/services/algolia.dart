import 'dart:convert';

import 'package:flutter/services.dart';

class AlgoliaAPI {

  static const platform = MethodChannel('com.algolia/api');

  Future<dynamic> search(String query) async {
    try {
      var response = await platform.invokeMethod('search', ['instant_search', query]);
      return jsonDecode(response);
    } on PlatformException catch (_) {
      return null;
    }
  }

}
