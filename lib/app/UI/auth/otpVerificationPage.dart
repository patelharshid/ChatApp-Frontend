import 'dart:async';
import 'package:chatapp/app/UI/auth/profileSetupPage.dart';
import 'package:chatapp/app/core/services/common_service.dart';
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
    for (var c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    enableResend = false;
    secondsRemaining = 60;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        setState(() => enableResend = true);
        timer.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  String getOtp() {
    return otpControllers.map((c) => c.text).join();
  }

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
      );
    } catch (e) {
      setState(() {
        errorMsg = "Invalid OTP. Please try again";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF2196F3), Color(0xFF64B5F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.message,
                      size: 50,
                      color: Color(0xFF1976D2),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Enter verification code",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "We've sent a 6-digit code to +91\n${widget.phone}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
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
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                        style: const TextStyle(color: Colors.red),
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
                        backgroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white54,
                        foregroundColor: const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF1976D2),
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
                        color: enableResend ? Colors.white : Colors.white70,
                      ),
                    ),
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
