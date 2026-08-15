import 'dart:async';

import 'package:cafe_app/feature/HomeScreem.dart';
import 'package:cafe_app/shared/color/colors.dart';
import 'package:cafe_app/core/api/auth_api.dart';
import 'package:cafe_app/core/auth/auth_session.dart';
import 'package:cafe_app/feature/auth/otp.dart';
import 'package:cafe_app/navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authApi = AuthApi();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isSignIn = true;
  bool _hoveringGoogle = false;
  bool _acceptedTerms = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _googleInitialized = false;

  static const _googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '284119455825-7b4qiarqesucrvq2ato9lnvt7i79o2ev.apps.googleusercontent.com',
  );

  void changeMode(bool signIn) {
    setState(() => isSignIn = signIn);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const NavigationMenu()),
      (route) => false,
    );
  }

  Future<void> _saveSessionAndGoHome() async {
    await AuthSession().save();
    if (!mounted) return;
    _goToHome();
  }



  Future<String?> _askForOtp(String phone) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => OtpDialog(
        phone: phone,
        onResend: () => _authApi.sendOtp(phone),
      ),
    );
  }

  Future<String?> _askForPhoneNumber() async {
    final phoneController = TextEditingController();
    try {
      return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.espresso.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.caramel,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.espresso,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Verify your phone',
                  style: GoogleFonts.fraunces(
                    color: AppColors.espresso,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your phone number to finish setting up your account. We will send you a verification code.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.clay,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PHONE NUMBER',
                    style: GoogleFonts.inter(
                      color: AppColors.clay,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+ -]')),
                  ],
                  decoration: InputDecoration(
                    hintText: '+855 92 000 000',
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.clay.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.clay,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.sand,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.caramel,
                        width: 1.6,
                      ),
                    ),
                  ),
                  onSubmitted: (value) => Navigator.pop(
                    dialogContext,
                    value.trim(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(
                      dialogContext,
                      phoneController.text.trim(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.espresso,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Send verification code',
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: AppColors.clay,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } finally {
      phoneController.dispose();
    }
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Enter your email and password.');
      return;
    }
    if (!isSignIn && (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty)) {
      _showMessage('Enter your full name and phone number.');
      return;
    }
    if (!isSignIn && password != _confirmPasswordController.text) {
      _showMessage('Passwords do not match.');
      return;
    }
    if (!isSignIn && !_acceptedTerms) {
      _showMessage('Please accept the terms to create an account.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (isSignIn) {
        await _authApi.login(email: email, password: password);
        if (mounted) _showMessage('Signed in successfully.');
        await _saveSessionAndGoHome();
      } else {
        final phone = _phoneController.text.trim();
        await _authApi.sendOtp(phone);
        if (!mounted) return;
        final otp = await _askForOtp(phone);
        if (otp == null || otp.isEmpty) return;
        await _authApi.verifyOtp(phone: phone, otp: otp);
        await _authApi.register(
          name: _nameController.text.trim(),
          email: email,
          phone: phone,
          password: password,
        );
        if (mounted) _showMessage('Account created successfully.');
        await _saveSessionAndGoHome();
      }
    } on AuthApiException catch (error) {
      if (mounted) _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isGoogleLoading = true;
    });
    try {
      if (!_googleInitialized) {
        await GoogleSignIn.instance.initialize(serverClientId: _googleWebClientId);
        _googleInitialized = true;
      }

      String? phone;
      if (!isSignIn && _phoneController.text.trim().isNotEmpty) {
        phone = _phoneController.text.trim();
        await _authApi.sendOtp(phone);
        if (!mounted) return;
        final otp = await _askForOtp(phone);
        if (otp == null || otp.isEmpty) return;
        await _authApi.verifyOtp(phone: phone, otp: otp);
      }

      final account = await GoogleSignIn.instance.authenticate();
      final auth = account.authentication;
      final idToken = auth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthApiException('Google did not return an ID token. Check the OAuth client setup.');
      }

      try {
        await _authApi.google(
          idToken: idToken,
          phone: phone,
          name: isSignIn ? null : _nameController.text.trim(),
        );
        if (mounted) _showMessage('Signed in with Google successfully.');
        await _saveSessionAndGoHome();
      } on AuthApiException catch (e) {
        final message = e.message.toLowerCase();
        final needsPhoneVerification =
            message.contains('phone') &&
            (message.contains('required') || message.contains('verify'));
        if (needsPhoneVerification) {
          if (!mounted) return;
          final newPhone = await _askForPhoneNumber();
          if (newPhone == null || newPhone.isEmpty) return;

          await _authApi.sendOtp(newPhone);
          if (!mounted) return;
          final otp = await _askForOtp(newPhone);
          if (otp == null || otp.isEmpty) return;
          await _authApi.verifyOtp(phone: newPhone, otp: otp);

          await _authApi.google(
            idToken: idToken,
            phone: newPhone,
            name: account.displayName,
          );
          if (mounted) _showMessage('Signed in with Google successfully.');
          await _saveSessionAndGoHome();
        } else {
          rethrow;
        }
      }
    } on AuthApiException catch (error) {
      if (mounted) _showMessage(error.message);
    } on GoogleSignInException catch (error) {
      if (mounted) _showMessage('Google sign-in failed: ${error.code}. Check the Android client and SHA-1.');
    } catch (_) {
      if (mounted) _showMessage('Google sign-in could not be completed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isSignIn ? 'Welcome Back' : 'Join Bassac Roasters';
    final subtitle = isSignIn
        ? 'Sign in to keep your rewards and order history.'
        : 'Create an account to earn points on every cup.';
    final textTheme = GoogleFonts.interTextTheme();
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/WelcomImage.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withValues(alpha: 0.45)),
                ),
                Positioned(
                  left: 25,
                  right: 25,
                  bottom: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.caramel,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.coffee_outlined,
                          color: AppColors.espresso,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        title,
                        style: GoogleFonts.fraunces(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.caramel,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 12,
                bottom: 12,
              ),
              color: AppColors.cream,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  AuthTabs(
                    isSignIn: isSignIn,
                    onChanged: changeMode,
                  ),
                  const SizedBox(height: 18),
                  _buildButtonGooglelogin(const AssetImage('assets/images/Google__G__logo.svg.webp')),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.latte.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'or use your email'.toUpperCase(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.espresso,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 100,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.latte.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (!isSignIn) ...[
                    _buildTextField('Full name', Icons.person_outline, controller: _nameController, hintText: 'Full Name'),
                    const SizedBox(height: 25),
                  ],
                  _buildTextField('Email', Icons.email_outlined, controller: _emailController),
                  const SizedBox(height: 25),
                  if (!isSignIn) ...[
                    _buildTextField('Phone', Icons.phone_outlined, controller: _phoneController, hintText: '+855 92 000 000'),
                    const SizedBox(height: 25),
                  ],
                  _buildTextField('Password', Icons.lock_outline, controller: _passwordController, obscureText: true),
                  if (!isSignIn) ...[
                    const SizedBox(height: 25),
                    _buildTextField('Confirm password', Icons.lock_outline, controller: _confirmPasswordController, obscureText: true),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _acceptedTerms,
                      onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.espresso,
                      title: Text(
                        'I agree to the terms of service and to receive order updates by SMS.',
                        style: GoogleFonts.inter(color: AppColors.clay, fontSize: 14),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: GoogleFonts.inter(
                            color: AppColors.clay,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.clay,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildButtonLogin(),
                  const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  HomeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          color: AppColors.mocha,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isSignIn ? 'New here?' : 'Already a member?', style: GoogleFonts.inter(color: AppColors.clay, fontSize: 15)),
                      TextButton(
                        onPressed: () => changeMode(!isSignIn),
                        child: Text(
                          isSignIn ? ' Create an account' : ' Sign in',
                          style: GoogleFonts.inter(
                            color: AppColors.mocha,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.latte,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
  }) {
    final lable = label;
    final String hintetext = lable == 'Email' ? 'Enter your email' : '••••••••';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable.toUpperCase(),
          style: GoogleFonts.inter(
            color: AppColors.clay,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            hintText: hintText ?? hintetext,
            hintStyle: GoogleFonts.inter(
              color: AppColors.clay.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(icon, color: AppColors.clay),
            suffixIcon: obscureText
                ? const Icon(Icons.visibility_outlined, color: AppColors.clay)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.sand, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.caramel, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonGooglelogin(AssetImage image) {
    final googleSignInText = _isGoogleLoading
        ? 'Connecting to Google…'
        : (isSignIn ? 'Continue with Google' : 'Sign up with Google');
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveringGoogle = true),
      onExit: (_) => setState(() => _hoveringGoogle = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _isLoading ? null : _signInWithGoogle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _hoveringGoogle ? AppColors.caramel : AppColors.sand,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isGoogleLoading)
                const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.espresso,
                  ),
                )
              else
                Image(image: image, height: 24, width: 24),
              const SizedBox(width: 8),
              Text(
                googleSignInText,
                style: GoogleFonts.inter(
                  color: AppColors.espresso,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogin() {
    final loginText = isSignIn ? 'Sign In' : 'Create Account';
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.espresso,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            Text(
              _isLoading ? 'Please wait...' : loginText,
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: AppColors.latte),
          ],
        ),
      ),
    );
  }
}

class AuthTabs extends StatelessWidget {
  const AuthTabs({
    super.key,
    required this.isSignIn,
    required this.onChanged,
  });

  final bool isSignIn;
  final ValueChanged<bool> onChanged;

  static const _radius = 14.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                left: isSignIn ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: BorderRadius.circular(_radius),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _tab(
                      label: 'Sign in',
                      selected: isSignIn,
                      onTap: () => onChanged(true),
                    ),
                  ),
                  Expanded(
                    child: _tab(
                      label: 'Register',
                      selected: !isSignIn,
                      onTap: () => onChanged(false),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final textTheme = GoogleFonts.interTextTheme();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_radius),
      child: Container(
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: (textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : AppColors.clay,
              )) ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.clay,
              ),
          child: Text(label),
        ),
      ),
    );
  }
}
