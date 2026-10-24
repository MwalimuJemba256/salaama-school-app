import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/salaama_app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatType = "Staff Chat";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: SalaamaAppBar(title: "Salaama Chat", backgroundColor: const Color(0xFF283593), bottom: TabBar(onTap: (i) => setState(() => chatType = ["Staff Chat", "Admin-Parent", "All Staff"][i]), tabs: const [Tab(text: "Staff"), Tab(text: "Parents"), Tab(text: "General")])),
        body: Column(children: [
          Expanded(child: _buildMessages()),
          _buildInput(),
        ]),
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chats').where('chatType', isEqualTo: chatType).orderBy('time', descending: true).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;
        return ListView.builder(reverse: true, itemCount: docs.length, itemBuilder: (context, i) {
          final d = docs[i].data();
          final isMe = d['senderEmail'] == FirebaseAuth.instance.currentUser?.email;
          return Align(alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.all(6), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isMe ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d['senderEmail'] ?? '', style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey)), Text(d['message'] ?? '', style: TextStyle(color: isMe ? Colors.white : Colors.black))])) );
        });
      },
    );
  }

  Widget _buildInput() {
    final ctrl = TextEditingController();
    return Padding(padding: const EdgeInsets.all(8), child: Row(children: [
      Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: "Type message...", border: OutlineInputBorder()))),
      IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: () async {
        if (ctrl.text.trim().isEmpty) return;
        await FirebaseFirestore.instance.collection('chats').add({
          'message': ctrl.text.trim(),
          'senderEmail': FirebaseAuth.instance.currentUser?.email ?? 'Admin',
          'chatType': chatType,
          'time': FieldValue.serverTimestamp(),
        });
        ctrl.clear();
      })
    ]));
  }
}
