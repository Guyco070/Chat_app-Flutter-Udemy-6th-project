import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        final curUser = FirebaseAuth.instance.currentUser!;
        return ListView.builder(
          itemBuilder: (context, index) => MessageBubble(chatDocs[index]['text'], chatDocs[index]['username'], chatDocs[index]['userImage'],curUser.uid == chatDocs[index]['userId'], key: ValueKey(chatDocs[index].id),),
          itemCount: chatDocs.length,
          reverse: true,
        );
      },
    );
  }
}
