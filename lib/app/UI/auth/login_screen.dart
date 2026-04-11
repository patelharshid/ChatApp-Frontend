import 'package:chatapp/app/UI/auth/otp_verification_screen.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:chatapp/app/core/widget/ch_button.dart';
import 'package:chatapp/app/core/widget/ch_text_field.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final LoginRepo loginRepo = LoginRepo();

  bool isLoading = false;
  String? error;

  Future<void> handleLogin() async {
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    final validationError = _validateInputs(phone, email);
    if (validationError != null) {
      setState(() => error = validationError);
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      await loginRepo.login(phone, email);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: phone),
        ),
      );
    } catch (e) {
      setState(() {
        error = "Login failed. Try again.";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String? _validateInputs(String phone, String email) {
    if (phone.isEmpty || phone.length != 10) {
      return "Enter a valid phone number";
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLG,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.message,
                      color: AppColors.primary,
                      size: AppConstants.iconLG,
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.heightLG),

                const Text(
                  "Enter your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: AppConstants.heightXS),

                const Text(
                  "We'll send you a verification code to confirm your number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.lightText, fontSize: 15),
                ),

                const SizedBox(height: AppConstants.heightXL),

                ChTextField(
                  controller: phoneController,
                  hintText: "Phone number",
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  showDivider: true,
                  prefix: const Text(
                    "+91",
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.heightMD),

                ChTextField(
                  controller: emailController,
                  hintText: "Email address",
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: AppConstants.heightMD),

                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.paddingSM,
                    ),
                    child: Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                ChButton(
                  title: "Send Code",
                  isLoading: isLoading,
                  onPressed: handleLogin,
                  textColor: AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
