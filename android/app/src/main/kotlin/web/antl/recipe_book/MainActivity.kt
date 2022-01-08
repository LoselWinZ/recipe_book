package web.antl.recipe_book

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    val algoliaAPIAdapter = AlgoliaAPIFlutterAdapter(ApplicationID("latency"), APIKey("90d33de3a50a968d12b11e179d817846"))

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.algolia/api").setMethodCallHandler { call, result ->
            algoliaAPIAdapter.perform(call, result)
        }
    }
}
