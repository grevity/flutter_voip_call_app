package com.grevity.flutter_voip_call_app

import android.annotation.SuppressLint
import android.content.Intent
import android.net.Uri
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

@SuppressLint("MissingFirebaseInstanceTokenRefresh")
class NotificationService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        if(remoteMessage.data.isNotEmpty()) {
            val intent = Intent(this, MainActivity::class.java)
            intent.putExtra("route","/incoming_call");
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent);
        }
    }
}