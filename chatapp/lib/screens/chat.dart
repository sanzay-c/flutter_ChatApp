import 'package:chatapp/widgets/chat_messages.dart';
import 'package:chatapp/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    fcm.subscribeToTopic('chat'); // push notification in targeted devices in one go using subscriberToTopic().

    // final token = await fcm.getToken();
    // print(token); // the generated token helps in push notification
  }

  @override
  void initState() {
    super.initState();

    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // this is use for logout
            },
            icon: Icon(
              Icons.logout_sharp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            // not to get rid of the error instead that ChatMessages can get as much space as it can get;
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
