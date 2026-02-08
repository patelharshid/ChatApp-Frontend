import 'package:chatapp/app/UI/auth/otpVerificationPage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/widget/ch_button.dart';
import 'package:chatapp/app/core/widget/ch_text_field.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  String? error;

  final LoginRepo loginRepo = LoginRepo();

  @override
  void initState() {
    super.initState();

    phoneController.addListener(_onTextChange);
    emailController.addListener(_onTextChange);
  }

  void _onTextChange() {
    setState(() {});
  }

  bool get isFormValid {
    return phoneController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty;
  }

  Future<void> validateAndSubmit() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      setState(() {
        isLoading = false;
        error = "Please enter a valid email address";
      });
      return;
    }

    try {
      await loginRepo.login(phone, email);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Otpverificationpage(phone: phone)),
      );
    } catch (_) {
      showError("Failed to send OTP. Please try again");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
        duration: const Duration(seconds: 2),
      ),
    );
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
      resizeToAvoidBottomInset: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(22),
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
                      size: 45,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Enter your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorWhite,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "We'll send you a verification code to confirm your number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),

                const SizedBox(height: 40),

                ChTextField(
                  controller: phoneController,
                  hintText: "Phone number",
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  showDivider: true,
                  prefix: const Text(
                    "+91",
                    style: TextStyle(
                      color: AppColors.colorWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ChTextField(
                  controller: emailController,
                  hintText: "Email address",
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.errorColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                ChButton(
                  title: "Send Code",
                  isLoading: isLoading,
                  isDisabled: !isFormValid,
                  onPressed: validateAndSubmit,
                  textColor: AppColors.colorBlack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
