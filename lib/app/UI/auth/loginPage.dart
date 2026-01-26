import 'package:chatapp/app/UI/auth/otpVerificationPage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/widget/ch_button.dart';
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

  Future<void> validateAndSubmit() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    if (phone.isEmpty) {
      setState(() => error = "Please enter phone number");
      return;
    }

    if (email.isEmpty) {
      setState(() => error = "Please enter email address");
      return;
    }

    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      setState(() => error = "Please enter a valid email address");
      return;
    }

    try {
      await loginRepo.login(phone, email);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Otpverificationpage(phone: phone)),
      );
    } catch (e) {
      showError("Failed to send OTP. Please try again");
    } finally {
      setState(() => isLoading = false);
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
            child: Padding(
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

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.background.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "+91",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhite,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 22,
                          width: 1.2,
                          color: AppColors.colorGrey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            cursorColor: AppColors.primary,
                            maxLength: 10,
                            style: const TextStyle(color: AppColors.colorWhite),
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: "Phone number",
                              hintStyle: TextStyle(color: AppColors.colorGrey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.colorBlack.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColors.primary,
                      style: const TextStyle(color: AppColors.colorWhite),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email address",
                        hintStyle: TextStyle(color: AppColors.colorGrey),
                      ),
                    ),
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
                    onPressed: validateAndSubmit,
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.colorBlack,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
