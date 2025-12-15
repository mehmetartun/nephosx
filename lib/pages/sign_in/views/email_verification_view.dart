import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EmailVerificationView extends StatefulWidget {
  final String actionCode;

  const EmailVerificationView({super.key, required this.actionCode});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _isVerified = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    try {
      await _auth.applyActionCode(widget.actionCode);
      // Reload current user to update emailVerified status if they are logged in.
      // But usually this link opens in a new browser/tab where user might not be logged in.
      if (_auth.currentUser != null) {
        await _auth.currentUser!.reload();
      }

      if (mounted) {
        setState(() {
          _isVerified = true;
          _isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isVerified = false;
          _errorMessage = _getErrorMessage(e);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isVerified = false;
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
      }
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'expired-action-code':
        return 'The verification link has expired.';
      case 'invalid-action-code':
        return 'The verification link is invalid. It may have been used already.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found for this verification link.';
      default:
        return e.message ?? 'Failed to verify email.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ),
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 600,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    if (_isLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      const Text("Verifying your email..."),
                    ] else if (_isVerified) ...[
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Email Verified Successfully!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "You can now sign in with your verified account.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      FilledButton(
                        onPressed: () {
                          context.go('/sign_in');
                        },
                        child: const Text("Continue to Sign In"),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Verification Failed",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage ?? "Unknown error",
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      FilledButton(
                        onPressed: () {
                          context.go('/sign_in');
                        },
                        child: const Text("Back to Sign In"),
                      ),
                    ],
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
