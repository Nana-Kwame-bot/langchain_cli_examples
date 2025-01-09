import "package:dash_chat_2/dash_chat_2.dart";
import "package:flutter/material.dart";

class Basic extends StatefulWidget {
  const Basic({super.key});

  @override
  _BasicState createState() => _BasicState();
}

class _BasicState extends State<Basic> {
  static ChatUser user = ChatUser(
    id: "1",
    firstName: "Charles",
    lastName: "Leclerc",
  );

  List<ChatMessage> messages = <ChatMessage>[
    ChatMessage(
      text: "Hey!",
      user: user,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic example"),
      ),
      body: DashChat(
        currentUser: user,
        onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);
          });
        },
        messages: messages,
      ),
    );
  }
}
