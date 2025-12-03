package com.example.movie_app

import io.flutter.embedding.android.FlutterActivity

import android.os.Build
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        createHighImportanceChannel()
    }

    private fun createHighImportanceChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "high_importance_channel"
            val channelName = "High Importance"
            val channel = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.description = "Used for important notifications"

            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }
}

