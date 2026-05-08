import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_notifiers.dart';
import '../../../config/app_translations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_refresh);
    localeNotifier.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    themeNotifier.removeListener(_refresh);
    localeNotifier.removeListener(_refresh);
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  bool get _isDark => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark;
    final bgColor =
        isDark ? const Color(0xFF1C2B3A) : const Color(0xFFB0BEC5);
    final fieldIconColor = isDark ? Colors.white60 : Colors.black54;
    final fieldTextColor = isDark ? Colors.white : Colors.black87;
    final fieldBorderColor = isDark ? Colors.white38 : Colors.black54;
    final fieldHintColor = isDark ? Colors.white38 : Colors.black45;
    final langActiveColor = isDark ? Colors.white : Colors.black87;
    final langInactiveColor = isDark ? Colors.white38 : Colors.black45;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          const _WaveHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  _buildTextField(
                    controller: _userController,
                    hint: tr('username'),
                    icon: Icons.person_outline,
                    iconColor: fieldIconColor,
                    textColor: fieldTextColor,
                    borderColor: fieldBorderColor,
                    hintColor: fieldHintColor,
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    iconColor: fieldIconColor,
                    textColor: fieldTextColor,
                    borderColor: fieldBorderColor,
                    hintColor: fieldHintColor,
                  ),
                  const SizedBox(height: 36),
                  _buildLoginButton(context),
                  const Spacer(),
                  _buildBottomRow(
                    isDark: isDark,
                    langActiveColor: langActiveColor,
                    langInactiveColor: langInactiveColor,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color borderColor,
    required Color hintColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 12),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: hintColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1E3A8A), width: 2),
              ),
              contentPadding: const EdgeInsets.only(bottom: 4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required Color iconColor,
    required Color textColor,
    required Color borderColor,
    required Color hintColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 12),
          child: Icon(Icons.lock_outline, color: iconColor, size: 24),
        ),
        Expanded(
          child: TextField(
            controller: _passController,
            obscureText: _obscurePassword,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: tr('password'),
              labelStyle: TextStyle(color: hintColor, fontSize: 13),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1E3A8A), width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: hintColor,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              contentPadding: const EdgeInsets.only(bottom: 4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.login, size: 20),
        label: Text(
          tr('login_btn'),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        onPressed: () => context.go('/products'),
      ),
    );
  }

  Widget _buildBottomRow({
    required bool isDark,
    required Color langActiveColor,
    required Color langInactiveColor,
  }) {
    final currentLang = localeNotifier.value.languageCode;
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1E3A8A),
          ),
          child: IconButton(
            iconSize: 26,
            icon: Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny,
              color: Colors.white,
            ),
            onPressed: () {
              themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLangButton('ES', 'es', currentLang, langActiveColor,
                langInactiveColor),
            _buildLangButton('EN', 'en', currentLang, langActiveColor,
                langInactiveColor),
          ],
        ),
      ],
    );
  }

  Widget _buildLangButton(
    String label,
    String code,
    String current,
    Color activeColor,
    Color inactiveColor,
  ) {
    final isActive = current == code;
    return TextButton(
      onPressed: () => localeNotifier.value = Locale(code),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? activeColor : inactiveColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _WaveHeader extends StatelessWidget {
  const _WaveHeader();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.27;
    return Stack(
      children: [
        ClipPath(
          clipper: const _WaveClipper(waveHeight: 0.78),
          child: Container(
            height: height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D2660), Color(0xFF1E3A8A)],
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: const _WaveClipper(waveHeight: 0.68),
          child: Container(
            height: height * 0.88,
            color: const Color(0xFF2A4FA8).withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper({required this.waveHeight});

  final double waveHeight;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * waveHeight);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * (waveHeight + 0.25),
      size.width * 0.55,
      size.height * waveHeight,
    );
    path.quadraticBezierTo(
      size.width * 0.78,
      size.height * (waveHeight - 0.22),
      size.width,
      size.height * waveHeight,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
