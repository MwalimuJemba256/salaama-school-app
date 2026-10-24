import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildLeaveScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  const ChildLeaveScreen({super.key, required this.student});
  @override
  State<ChildLeaveScreen> createState() => _ChildLeaveScreenState();
}

class _ChildLeaveScreenState extends State<ChildLeaveScreen> {
  String _reason = 'Graduated';
  final _controller = TextEditingController();
  bool _loading = false;

  final reasons = ['Graduated', 'Transferred', 'Fees Issue', 'Disciplinary', 'Parent Request', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red[700], title: Text('Leave: ${widget.student['fullName']}', style: const TextStyle(color: Colors.white)), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundImage: widget.student['photoUrl'] != '' && widget.student['photoUrl'] != null ? NetworkImage(widget.student['photoUrl']) : null, child: widget.student['photoUrl'] == '' ? const Icon(Icons.person, size: 50) : null),
            const SizedBox(height: 12),
            Text(widget.student['fullName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('${widget.student['studentId']} • ${widget.student['class']}'),
            const SizedBox(height: 20),
            DropdownButtonFormField(value: _reason, items: reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(), onChanged: (v) => setState(() => _reason = v!), decoration: const InputDecoration(labelText: 'Reason for Leaving', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _controller, maxLines: 3, decoration: const InputDecoration(labelText: 'Details (Optional)', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]), onPressed: _loading ? null : () async {
              setState(() => _loading = true);
              await FirebaseFirestore.instance.collection('students').doc(widget.student['id'] ?? widget.student['studentId']).update({'status': 'Left', 'leaveReason': _reason, 'leaveDetails': _controller.text, 'leftAt': FieldValue.serverTimestamp()});
              await FirebaseFirestore.instance.collection('left_students').add({...widget.student, 'leaveReason': _reason, 'leaveDetails': _controller.text, 'leftAt': FieldValue.serverTimestamp()});
              if (context.mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red[700], content: Text('${widget.student['fullName']} marked as Left'))); Navigator.pop(context); }
              setState(() => _loading = false);
            }, child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('CONFIRM LEAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
}
