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

  static ChatUser user3 = ChatUser(id: "3", lastName: "Clark");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic example"),
      ),
      body: DashChat(
        messageListOptions: MessageListOptions(),
        messageOptions: MessageOptions(
          onTapMedia: (media) {
            final media = ChatMedia(
              url: "google.com",
              fileName: "google",
              type: MediaType.image,
            );

            setState(() {
              messages.insert(
                  0,
                  ChatMessage(
                    medias: [media],
                    user: user,
                    createdAt: DateTime.now(),
                  ));
            });
          },
        ),
        currentUser: user,
        onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);
          });
        },
        messages: messages,
        inputOptions: const InputOptions(
          sendOnEnter: true,
        ),
      ),
    );
  }
}
