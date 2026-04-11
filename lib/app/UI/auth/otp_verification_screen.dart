import 'dart:async';
import 'package:chatapp/app/UI/auth/profile_setup_screen.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:chatapp/app/core/widget/ch_button.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final LoginRepo loginRepository = LoginRepo();

  int remainingSeconds = 60;
  bool canResendOtp = false;
  bool isVerifyingOtp = false;
  String? otpErrorMessage;
  Timer? countdownTimer;

  String enteredOtp = "";

  @override
  void initState() {
    super.initState();
    startOtpCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startOtpCountdown() {
    canResendOtp = false;
    remainingSeconds = 60;

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        setState(() => canResendOtp = true);
        timer.cancel();
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  bool get isOtpComplete => enteredOtp.length == 6;

  Future<void> verifyOtp() async {
    if (isVerifyingOtp || !isOtpComplete) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isVerifyingOtp = true;
      otpErrorMessage = null;
    });

    try {
      final response = await loginRepository.otpVerification(
        widget.phoneNumber,
        enteredOtp,
      );

      await CommonService.setToken(response['data']);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
      );
    } catch (e) {
      setState(() {
        otpErrorMessage = "Invalid OTP. Please try again";
      });
    } finally {
      if (mounted) {
        setState(() => isVerifyingOtp = false);
      }
    }
  }

  Future<void> resendOtpCode() async {
    if (!canResendOtp) return;

    try {
      setState(() {
        canResendOtp = false;
        remainingSeconds = 60;
      });

      await loginRepository.resendOtp(widget.phoneNumber);
      startOtpCountdown();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to resend OTP. Try again."),
          backgroundColor: AppColors.error,
        ),
      );

      setState(() => canResendOtp = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.mid, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLG,
              vertical: AppConstants.paddingXL,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppConstants.heightXL),

                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.message,
                    size: AppConstants.iconLG,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppConstants.heightLG),

                const Text(
                  "Enter verification code",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: AppConstants.heightXS),

                Text(
                  "We've sent a 6-digit code to +91\n${widget.phoneNumber}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.lightText,
                  ),
                ),

                const SizedBox(height: AppConstants.heightXL),

                OtpTextField(
                  numberOfFields: 6,
                  borderColor: AppColors.primary,
                  focusedBorderColor: AppColors.primary,
                  enabledBorderColor: AppColors.primary.withValues(alpha: 0.5),
                  showFieldAsBox: true,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                  fieldWidth: 45,
                  fieldHeight: 55,
                  textStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: AppColors.surface,
                  filled: true,
                  onCodeChanged: (value) {
                    enteredOtp = value;

                    if (otpErrorMessage != null) {
                      setState(() => otpErrorMessage = null);
                    }
                  },
                  onSubmit: (value) {
                    enteredOtp = value;
                  },
                ),

                const SizedBox(height: AppConstants.heightLG),

                if (otpErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.paddingSM,
                    ),
                    child: Text(
                      otpErrorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                ChButton(
                  title: "Verify Code",
                  isLoading: isVerifyingOtp,
                  isDisabled: !isOtpComplete,
                  onPressed: verifyOtp,
                  textColor: AppColors.black,
                ),

                const SizedBox(height: AppConstants.heightMD),

                TextButton(
                  onPressed: canResendOtp ? resendOtpCode : null,
                  child: Text(
                    canResendOtp
                        ? "Resend Code"
                        : "Resend in $remainingSeconds s",
                    style: TextStyle(
                      color: canResendOtp
                          ? AppColors.white
                          : AppColors.lightText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
