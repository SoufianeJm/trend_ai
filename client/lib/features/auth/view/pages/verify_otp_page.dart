import 'package:flutter/material.dart';
import 'package:client/core/services/auth_service.dart';

class VerifyOtpPage extends StatefulWidget {
  final String verificationId;
  final String firstName;
  final String lastName;
  final String phone;

  const VerifyOtpPage({
    super.key,
    required this.verificationId,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _otpController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the verification code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Verify OTP
      final userCredential = await _authService.signInWithOtp(
        verificationId: widget.verificationId,
        otp: _otpController.text,
      );

      // Store user data in Firestore
      await _authService.storeUserData(
        firstName: widget.firstName,
        lastName: widget.lastName,
        phone: widget.phone,
        password: 'temp_password', // You might want to handle this differently
      );

      if (mounted) {
        // Navigate to home or next screen
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to verify code: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter the verification code sent to your phone',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
                hintText: '123456',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
} 