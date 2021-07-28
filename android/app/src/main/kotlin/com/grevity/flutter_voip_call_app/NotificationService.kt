package com.grevity.flutter_voip_call_app

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.view.WindowManager
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.flutter.app.FlutterActivity

@SuppressLint("MissingFirebaseInstanceTokenRefresh")
class NotificationService : FirebaseMessagingService() {
    lateinit var notificationManager : NotificationManager
    lateinit var notificationChannel : NotificationChannel
    lateinit var builder : Notification.Builder
    val channelId = "com.grevity.delve_app"
    val description = "Test notification"
    val context = this
    @SuppressLint("WrongConstant")
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d("remote message", remoteMessage.data.toString());
        Log.v("remote message", remoteMessage.data.toString());
        Log.w("remote message", remoteMessage.data.toString());
        if(remoteMessage.data.isNotEmpty()) {
            val intent = Intent(this, MainActivity::class.java)
//            intent.putExtra("route","dashboard");
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent);
        }

//        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//        remoteMessage.data.isNotEmpty().let {
//            Log.d("MyFirebaseService", "Message data payload: " + remoteMessage.notification)
//            // db.insertData(Temp(remoteMessage.data["message"].toString()))
//
//            val intent = Intent(this,MainActivity::class.java)
//            val pendingIntent = PendingIntent.getActivity(this,0,intent,PendingIntent.FLAG_UPDATE_CURRENT)
//
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                notificationChannel = NotificationChannel(channelId,description,NotificationManager.IMPORTANCE_HIGH)
//                notificationChannel.enableVibration(true)
//                notificationManager.createNotificationChannel(notificationChannel)
//                builder = Notification.Builder(this,channelId)
//                        .setContentTitle(remoteMessage.data["title"].toString()).setContentText(remoteMessage.data["body"].toString())
//                        .setContentIntent(pendingIntent)
//
//            }else{
//                builder = Notification.Builder(this)
//                        .setContentTitle(remoteMessage.data["title"].toString()).setContentText(remoteMessage.data["body"].toString())
//                        .setContentIntent(pendingIntent)
//            }
//            notificationManager.notify(1234,builder.build())
//        }
    }
}