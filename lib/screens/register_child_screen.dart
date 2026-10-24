import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';

class RegisterChildScreen extends StatefulWidget {
  const RegisterChildScreen({super.key});

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _previousSchoolController = TextEditingController();
  final _healthController = TextEditingController();

  String? _selectedClass;
  String? _selectedGender = 'Male';
  DateTime? _dob;
  File? _photoFile;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0D5A2D)),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: Color(0xFF0D5A2D)),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final picked = await _picker.pickImage(source: source, imageQuality: 70);
      if (picked != null) {
        setState(() => _photoFile = File(picked.path));
      }
    }
  }

  Future<String> _uploadPhoto(String studentId) async {
    if (_photoFile == null) return '';
    final ref = FirebaseStorage.instance
        .ref()
        .child('students_photos')
        .child('$studentId.jpg');
    await ref.putFile(_photoFile!);
    return await ref.getDownloadURL();
  }

  Future<void> _registerChild() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select class')),
      );
      return;
    }
    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date of birth')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uuid = const Uuid().v4();
      final studentId = 'SMS/${DateTime.now().year}/${uuid.substring(0, 4).toUpperCase()}';
      
      String photoUrl = '';
      if (_photoFile != null) {
        photoUrl = await _uploadPhoto(uuid);
      }

      await FirebaseFirestore.instance.collection('students').doc(uuid).set({
        'id': uuid,
        'studentId': studentId,
        'fullName': _nameController.text.trim(),
        'gender': _selectedGender,
        'dob': _dob!.toIso8601String(),
        'class': _selectedClass,
        'parentName': _parentNameController.text.trim(),
        'parentPhone': _parentPhoneController.text.trim(),
        'village': _villageController.text.trim(),
        'previousSchool': _previousSchoolController.text.trim(),
        'healthInfo': _healthController.text.trim(),
        'photoUrl': photoUrl,
        'status': 'Active', // Active, Left, Suspended
        'leaveDate': null,
        'leaveReason': null,
        'admissionDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'feeBalance': 0,
        'attendance': 100,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF0D5A2D),
          content: Text('Child Registered: $studentId'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D5A2D),
        title: const Text('Register New Child', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // PHOTO SPACE - PROFESSIONAL
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0D5A2D), width: 3),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                        image: _photoFile != null
                            ? DecorationImage(image: FileImage(_photoFile!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _photoFile == null
                          ? const Icon(Icons.person, size: 60, color: Color(0xFF0D5A2D))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickPhoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D5A2D),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _pickPhoto,
                child: const Text('Tap to add child photo', style: TextStyle(color: Color(0xFF0D5A2D))),
              ),
              const SizedBox(height: 20),

              // FORM FIELDS - PROFESSIONAL
              _buildTextField(_nameController, 'Full Name (As in Birth Certificate)', Icons.child_care, true),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: _inputDec('Gender', Icons.wc),
                      items: ['Male', 'Female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setState(() => _selectedGender = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2018),
                          firstDate: DateTime(2005),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _dob = picked);
                      },
                      child: InputDecorator(
                        decoration: _inputDec('Date of Birth', Icons.cake),
                        child: Text(_dob == null ? 'Select DOB' : '${_dob!.day}/${_dob!.month}/${_dob!.year}'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: _inputDec('Class - Nursery to P7', Icons.class_),
                items: AppConstants.classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedClass = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              _buildTextField(_parentNameController, 'Parent / Guardian Name', Icons.person_outline, true),
              const SizedBox(height: 12),
              _buildTextField(_parentPhoneController, 'Parent Phone (07... )', Icons.phone, true, isPhone: true),
              const SizedBox(height: 12),
              _buildTextField(_villageController, 'Village / Address', Icons.location_on, false),
              const SizedBox(height: 12),
              _buildTextField(_previousSchoolController, 'Previous School (If any)', Icons.school, false),
              const SizedBox(height: 12),
              _buildTextField(_healthController, 'Health Info / Allergies', Icons.health_and_safety, false, maxLines: 2),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D5A2D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _registerChild,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('REGISTER CHILD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Salaama Muslim Junior School - Destined to Succeed', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF0D5A2D)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D5A2D), width: 2)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, bool required, {bool isPhone = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: _inputDec(label, icon),
      validator: required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
    );
  }
}
