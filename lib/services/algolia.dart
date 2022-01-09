import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlgoliaAPI {

  static const Algolia algolia = Algolia.init(
    applicationId: 'Q3QCSBX33G',
    apiKey: '90d33de3a50a968d12b11e179d817846',
  );

  Future<List<AlgoliaObjectSnapshot>?> search(String query, [String? index]) async {
    try {
      AlgoliaQuerySnapshot response = await algolia.instance.index(index ?? 'ingredients').setHitsPerPage(5).setMaxFacetHits(5).query(query).getObjects();
      return response.hits;
    } on PlatformException catch (_) {
      return null;
    }
  }

}
