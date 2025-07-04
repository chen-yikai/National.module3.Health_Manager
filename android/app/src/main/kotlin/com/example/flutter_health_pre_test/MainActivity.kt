package com.example.flutter_health_pre_test

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.flutter_health_pre_test/method"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "write_history" -> {
                    try {
                        val jsonString = call.arguments as String
                        File(filesDir, "history.json").writeText(jsonString)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("WRITE_HISTORY_ERROR", "error", e.message)
                    }
                }

                "get_history" -> {
                    try {
                        val jsonString = File(filesDir, "history.json").readText()
                        result.success(jsonString)
                    } catch (e: Exception) {
                        result.error("GET_HISTORY_ERROR", "error", e.message)
                    }
                }

                "write_exercise" -> {
                    try {
                        val jsonString = call.arguments as String
                        File(filesDir, "exercise.json").writeText(jsonString)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("WRITE_HISTORY_ERROR", "error", e.message)
                    }
                }

                "get_exercise" -> {
                    try {
                        val jsonString = File(filesDir, "exercise.json").readText()
                        result.success(jsonString)
                    } catch (e: Exception) {
                        result.error("GET_HISTORY_ERROR", "error", e.message)
                    }
                }

                "write_workout" -> {
                    try {
                        val jsonString = call.arguments as String
                        File(filesDir, "workout.json").writeText(jsonString)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("WRITE_HISTORY_ERROR", "error", e.message)
                    }
                }

                "get_workout" -> {
                    try {
                        val jsonString = File(filesDir, "workout.json").readText()
                        result.success(jsonString)
                    } catch (e: Exception) {
                        result.error("GET_HISTORY_ERROR", "error", e.message)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
