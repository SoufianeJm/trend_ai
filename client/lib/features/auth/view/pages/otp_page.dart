import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/custom_button.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onChanged(int idx, String value) {
    if (value.length == 1 && idx < 5) {
      _focusNodes[idx + 1].requestFocus();
    } else if (value.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> _handleContinue() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    // Simulate OTP check
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    // TODO: Implement OTP verification logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP logic not implemented.')),
    );
  }

  void _handleResend() {
    // TODO: Implement resend logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resend code logic not implemented.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Enter the code',
                style: AppTypography.h4.copyWith(color: Palette.gray900),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit code to',
                style: AppTypography.bodyRegular16.copyWith(color: Palette.gray400),
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: AppTypography.bodyMedium16.copyWith(color: Palette.gray900),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (idx) {
                  return SizedBox(
                    width: 44,
                    child: TextField(
                      controller: _controllers[idx],
                      focusNode: _focusNodes[idx],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTypography.h4.copyWith(color: Palette.gray900),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.all(0),
                        filled: true,
                        fillColor: Palette.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Palette.gray200, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Palette.gray200, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Palette.primary, width: 2),
                        ),
                      ),
                      onChanged: (value) => _onChanged(idx, value),
                    ),
                  );
                }),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: AppTypography.bodyRegular12.copyWith(color: Palette.error),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Continue',
                  size: ButtonSize.large,
                  variant: ButtonVariant.primary,
                  onPressed: _otp.length == 6 && !_isLoading ? _handleContinue : null,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: _handleResend,
                  child: Text(
                    'Resend code',
                    style: AppTypography.bodyMedium14.copyWith(
                      color: Palette.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 