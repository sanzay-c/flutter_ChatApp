import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {

    final enteredMessage = _messageController
        .text; // .text => is a String. it returns the entered text as a string;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); // this hepls to immediately close the keyboard when the data is 22send;
    _messageController.clear(); // .clear() sets to empty;

    final user = FirebaseAuth.instance.currentUser!;

    /* 'users' collection because that's the collection also used for storing the data .
        it's like retrieving the data form the firestore; 
        getting the data.
    */
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      // and using the data that is retrieved,
      'username': userData.data()!['username'], // ['username'] key because that's the name used in storing the data;  and retrieving the username from firestore.
      'userImage': userData.data()!['image_url'], // ['image_url'] key because that's the name used in storing the data; and retrieving the username from firestore.
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'send a message...'),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send_outlined),
          ),
        ],
      ),
    );
  }
}
