package com.ink2latex.ink2latex

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class GemmaBridge(private val engine: FlutterEngine) {
    companion object {
        const val CHANNEL = "com.ink2latex/gemma"
    }

    fun register() {
        MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "recognize") {
                    // TODO: Integrate Gemma E2B via Android AICore
                    result.success(mapOf("text" to "", "confidence" to 0.0))
                } else {
                    result.notImplemented()
                }
            }
    }
}
