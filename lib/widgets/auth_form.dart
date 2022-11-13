import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  AuthForm({super.key, required this.submitFn, required this.isLoading});
  final void Function(String email, String userName, String password, File? image,
      bool isLogin, BuildContext ctx) submitFn;
  bool isLoading;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // close keyboard

    if (!_isLogin && _userImageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text('Please pick an image.'), backgroundColor: Theme.of(context).errorColor,));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userName.trim(), _userPassword.trim(), _userImageFile,
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email adress.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Adress',
                      ),
                      onSaved: (newValue) => _userEmail = newValue!,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        onSaved: (newValue) => _userName = newValue!,
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 charachters long.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      onSaved: (newValue) => _userPassword = newValue!,
                    ),
                    const SizedBox(height: 12),
                    widget.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _trySubmit,
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                    if (!widget.isLoading)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'I already have an account'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
