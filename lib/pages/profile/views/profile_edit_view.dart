import 'package:nephosx/widgets/formfields/image_form_field.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/user.dart';

class ProfileEditView extends StatefulWidget {
  final User user;
  final void Function() onCancel;
  final void Function(Map<String, dynamic> data) onUpdate;
  const ProfileEditView({
    super.key,
    required this.user,
    required this.onCancel,
    required this.onUpdate,
  });

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _displayNameController;
  String? _photoBase64;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _displayNameController = TextEditingController(
      text: widget.user.displayName,
    );
    _photoBase64 = widget.user.photoBase64;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updates = {
        'uid': widget.user.uid, // Important for identifying the document
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'display_name': _displayNameController.text,
        'photo_base64': _photoBase64,
      };

      // Call the cubit to update the user data
      widget.onUpdate(updates);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Edit Profile'),
      //   actions: [
      //     // IconButton(
      //     //   icon: const Icon(Icons.save),
      //     //   onPressed: _saveProfile,
      //     //   tooltip: 'Save',
      //     // ),
      //     IconButton(icon: const Icon(Icons.close), onPressed: widget.onCancel),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Edit Profile'),
            backgroundColor: Colors.transparent,

            actions: [
              // IconButton(
              //   icon: const Icon(Icons.save),
              //   onPressed: _saveProfile,
              //   tooltip: 'Save',
              // ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onCancel,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: MaxWidthBox(
                maxWidth: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ImageFormfield(
                      onSaved: (value) {
                        _photoBase64 = value;
                      },
                      onValidate: (value) {
                        return null;
                      },
                      initialValue: widget.user.photoBase64,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: 'First Name',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a first name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        filled: true,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a last name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        filled: true,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a display name' : null,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(child: Text("Save"), onPressed: _saveProfile),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
