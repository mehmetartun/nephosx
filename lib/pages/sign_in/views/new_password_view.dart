import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String actionCode;
  final String? mode;

  const ResetPasswordScreen({super.key, required this.actionCode, this.mode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _email; // To show the user who they are resetting for

  @override
  void initState() {
    super.initState();
    _verifyCode();
  }

  // OPTIONAL: Verify the code immediately to get the user's email address
  Future<void> _verifyCode() async {
    try {
      setState(() => _isLoading = true);
      // This checks if the link is valid and returns the email associated with it
      String email = await _auth.verifyPasswordResetCode(widget.actionCode);
      setState(() {
        _email = email;
        _isLoading = false;
      });
    } catch (e) {
      // If code is invalid (expired/already used), send them back to login
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid or expired link: $e')));
        context.go('/sign_in');
      }
    }
  }

  Future<void> _submitNewPassword() async {
    if (_passwordController.text.isEmpty) return;

    try {
      setState(() => _isLoading = true);

      // CONFIRM THE CHANGE
      await _auth.confirmPasswordReset(
        code: widget.actionCode,
        newPassword: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
        // Navigate to login or home
        context.go('/sign_in');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _email == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // appBar: AppBar(title: const Text("Reset Password")),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "NephosX",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
            centerTitle: true,
            toolbarHeight: 100,
            pinned: true,
            snap: true,
            floating: true,
            // backgroundColor: Colors.transparent,
            // expandedHeight: 200,
            // flexibleSpace: FlexibleSpaceBar(
            //   background: Image.asset(
            //     "assets/images/nephosx2/nephosx.png",
            //     fit: BoxFit.fitHeight,
            //   ),
            //   title: Text("Sign In"),
            // ),
          ),
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 600,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Resetting password for: $_email",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "New Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,

                      child: FilledButton(
                        onPressed: _isLoading ? null : _submitNewPassword,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Update Password"),
                      ),
                    ),
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
