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
  String selectedType = "All";
  final List<String> types = ["All", "Staff Chat", "Parents", "General"];
  final TextEditingController msgCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: const SalaamaAppBar(title: "Salaama Chat", backgroundColor: Color(0xFF283593)),
      body: Column(children: [
        // Filter Chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: types.map((t) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(t),
                  selected: selectedType == t,
                  selectedColor: const Color(0xFF283593).withOpacity(0.15),
                  onSelected: (_) => setState(() => selectedType = t),
                ),
              )).toList(),
            ),
          ),
        ),
        // Messages
        Expanded(child: _buildMessages()),
        // Input
        _buildInput(),
      ]),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder(
      // NO where filter - to avoid index error - filter in code
      stream: FirebaseFirestore.instance.collection('chats').orderBy('time', descending: true).limit(200).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        var docs = snap.data!.docs;
        // Filter client-side - NO INDEX NEEDED
        if (selectedType != "All") {
          docs = docs.where((d) => (d.data()['chatType'] ?? 'General') == selectedType).toList();
        }
        if (docs.isEmpty) return Center(child: Text("No messages in $selectedType yet\nStart chatting!", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)));

        return ListView.builder(
          reverse: true,
          controller: scrollCtrl,
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data();
            final isMe = data['senderEmail'] == FirebaseAuth.instance.currentUser?.email;
            final time = (data['time'] as Timestamp?)?.toDate();
            final timeStr = time != null ? "${time.hour}:${time.minute.toString().padLeft(2, '0')}" : "";

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF283593) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (!isMe) Text(data['senderName'] ?? data['senderEmail'] ?? 'User', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF283593))),
                  Text(data['message'] ?? '', style: TextStyle(fontSize: 14, color: isMe ? Colors.white : Colors.black87)),
                  const SizedBox(height: 2),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Text("${data['chatType'] ?? 'General'} • $timeStr", style: TextStyle(fontSize: 9, color: isMe ? Colors.white70 : Colors.grey)),
                  ]),
                ]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: msgCtrl,
            decoration: InputDecoration(
              hintText: "Message to $selectedType...",
              filled: true,
              fillColor: const Color(0xFFF5F7FB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: const Color(0xFF283593),
          child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: _sendMessage),
        )
      ]),
    );
  }

  Future<void> _sendMessage() async {
    if (msgCtrl.text.trim().isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get user name from users collection
    String senderName = user.email ?? 'User';
    try {
      final uDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (uDoc.exists) senderName = uDoc.data()?['name'] ?? senderName;
    } catch (_) {}

    await FirebaseFirestore.instance.collection('chats').add({
      'message': msgCtrl.text.trim(),
      'senderEmail': user.email,
      'senderName': senderName,
      'senderUid': user.uid,
      'chatType': selectedType == "All" ? "General" : selectedType,
      'time': FieldValue.serverTimestamp(),
    });
    msgCtrl.clear();
  }
}
