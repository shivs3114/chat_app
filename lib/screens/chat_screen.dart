import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String? text;
  void getUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        print(user.email);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  );
                }

                final messages = snapshot.data!.docs;
                List<MessageBubble> messagesBubbles = [];
                for (var message in messages) {
                  Map<String, dynamic> data =
                      message.data() as Map<String, dynamic>;
                  final messageText = data['Text'];
                  final mSender = data['sender'];
                  final widget = MessageBubble(
                    sender: mSender,
                    text: messageText,
                  );
                  messagesBubbles.add(widget);
                }
                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    children: messagesBubbles,
                    scrollDirection: Axis.vertical,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageController.clear();
                      _firestore.collection('messages').add(
                          {'text': text, 'sender': _auth.currentUser?.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String? sender;
  final String? text;
  MessageBubble({this.sender, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Material(
              borderRadius: BorderRadius.circular(30),
              elevation: 5.0,
              color: Colors.green,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  text!,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            Text(
              sender!,
              style: TextStyle(fontSize: 12, color: Colors.black26),
            ),
          ],
        ));
  }
}
