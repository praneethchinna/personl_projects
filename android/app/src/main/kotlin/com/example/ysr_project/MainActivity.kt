package com.example.ysr_project
import android.media.MediaScannerConnection
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "gallery_scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "refreshGallery") {
                    val filePath = call.argument<String>("filePath")
                    refreshGallery(filePath ?: "")
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun refreshGallery(filePath: String) {
        MediaScannerConnection.scanFile(this, arrayOf(filePath), null) { path, uri ->
            println("✅ Media Scanner refreshed: $path")
        }
    }
}

