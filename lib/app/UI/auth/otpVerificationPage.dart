import 'dart:async';
import 'package:chatapp/app/UI/auth/profileSetupPage.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';

class Otpverificationpage extends StatefulWidget {
  final String phone;

  const Otpverificationpage({super.key, required this.phone});

  @override
  State<Otpverificationpage> createState() => _OtpverificationpageState();
}

class _OtpverificationpageState extends State<Otpverificationpage> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int secondsRemaining = 60;
  bool enableResend = false;
  bool isLoading = false;
  String? errorMsg;
  Timer? timer;

  final LoginRepo loginRepo = LoginRepo();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    enableResend = false;
    secondsRemaining = 60;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        setState(() => enableResend = true);
        t.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  String getOtp() => otpControllers.map((c) => c.text).join();

  Future<void> verifyOtpApi() async {
    final otp = getOtp();
    if (otp.length != 6) return;

    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    try {
      final res = await loginRepo.otpVerification(widget.phone, otp);
      CommonService.setToken(res['data']);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
      );
    } catch (_) {
      setState(() => errorMsg = "Invalid OTP. Please try again");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.colorWhite),
        centerTitle: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
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
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Enter verification code",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorWhite,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "We've sent a 6-digit code to +91\n${widget.phone}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.lightText,
                  ),
                ),

                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 60,
                      child: TextField(
                        controller: otpControllers[index],
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        cursorColor: AppColors.primary,
                        style: const TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.6),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                          setState(() {});
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 30),

                if (errorMsg != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      errorMsg!,
                      style: const TextStyle(
                        color: AppColors.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: getOtp().length == 6 && !isLoading
                        ? verifyOtpApi
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withValues(
                        alpha: 0.5,
                      ),
                      foregroundColor: AppColors.colorBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.colorBlack,
                          )
                        : const Text(
                            "Verify Code",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: enableResend ? startTimer : null,
                  child: Text(
                    enableResend
                        ? "Resend Code"
                        : "Resend in $secondsRemaining s",
                    style: TextStyle(
                      color: enableResend
                          ? AppColors.colorWhite
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
