import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    NotificationSettings settings = await

mkdir -p lib/services

cat > lib/services/chat_service.dart << 'EOF'
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final _chats = FirebaseFirestore.instance.collection('chats');

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _chats.doc(chatId).collection('messages').orderBy('timestamp').snapshots();
  }

  Future<void> sendMessage(String chatId, String senderId, String text) async {
    await _chats.doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
