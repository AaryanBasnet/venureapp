import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venure/core/utils/url_utils.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_state.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;
  String? _address;
  File? _avatarFile;

  @override
  Widget build(BuildContext context) {
    final state = context.read<ProfileViewModel>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child:
                      _avatarFile != null
                          ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_avatarFile!),
                          )
                          : (state.avatar != null
                              ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  UrlUtils.buildFullUrl(state.avatar!),
                                ),
                              )
                              : CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              )),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: state.name,
                decoration: const InputDecoration(labelText: "Name"),
                onSaved: (value) => _name = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: state.phone,
                decoration: const InputDecoration(labelText: "Phone"),
                onSaved: (value) => _phone = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: state.address,
                decoration: const InputDecoration(labelText: "Address"),
                onSaved: (value) => _address = value,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final extension = picked.path.split('.').last;
      print('Picked file path: ${picked.path}');
      print('File extension: $extension');

      setState(() {
        _avatarFile = File(picked.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context.read<ProfileViewModel>().add(
        UpdateUserProfile(
          name: _name.toString(),
          phone: _phone.toString(),
          address: _address.toString(),
          avatarFile: _avatarFile,
        ),
      );

      Navigator.pop(context);
    }
  }
}
