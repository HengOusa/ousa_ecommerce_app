import 'dart:ui';
import 'package:ecom_app/app/routes/app_routes.dart';
import 'package:ecom_app/core/localization/translate_extension.dart';
import 'package:ecom_app/core/responsive/responsive_layout.dart';
import 'package:ecom_app/core/services/localization_provider.dart';
import 'package:ecom_app/features/auth/presentation/providers/login_provider.dart';
import 'package:ecom_app/features/auth/presentation/validators/login_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final login = context.watch<LoginProvider>();
    final localization = context.watch<LocalizationProvider>();
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final successMessage = 'login.success'.tr(context);
    return Scaffold(
      backgroundColor: dark ? const Color(0xFF101827) : const Color(0xFFF0F5F2),
      body: Stack(
        children: [
          const Positioned.fill(child: _GlassBackground()),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final maxWidth = width >= 1024
                    ? 440.0
                    : width >= 600
                    ? 480.0
                    : 560.0;

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Center(
                    child: ResponsiveLayout(
                      maxWidth: maxWidth,
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          _BrandHeader(dark: dark),

                          const SizedBox(height: 28),

                          _GlassCard(
                            dark: dark,
                            child: Form(
                              key: login.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Welcome Back',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                        ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    'Sign in to continue shopping.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  _GlassTextField(
                                    label: 'login.email'.tr(context),
                                    hint: 'Enter your email address',
                                    controller: login.emailController,
                                    icon: Iconsax.sms,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: LoginValidator.validateEmail,
                                    dark: dark,
                                  ),

                                  const SizedBox(height: 22),

                                  _GlassTextField(
                                    label: 'login.password'.tr(context),
                                    hint: 'Enter your password',
                                    controller: login.passwordController,
                                    icon: Iconsax.lock,
                                    obscureText: login.isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    validator: LoginValidator.validatePassword,
                                    dark: dark,
                                    suffix: IconButton(
                                      tooltip: login.isPasswordVisible
                                          ? 'Hide password'
                                          : 'Show password',
                                      onPressed: login.togglePasswordVisibility,
                                      icon: Icon(
                                        !login.isPasswordVisible
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                        color: theme.colorScheme.primary,
                                        size: 21,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  _GlassLoginButton(
                                    loading: login.isLoading,
                                    onPressed: () async {
                                      if (login.isLoading) return;

                                      final success = await login.login();

                                      if (!context.mounted) return;

                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(successMessage),
                                          ),
                                        );

                                        context.goNamed(AppRoutes.layout);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              login.errorMessage ??
                                                  'Login failed.',
                                            ),
                                            backgroundColor:
                                                theme.colorScheme.error,
                                          ),
                                        );
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 28),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color:
                                              theme.colorScheme.outlineVariant,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        child: Text(
                                          'login.or_continue_with'.tr(context),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color:
                                              theme.colorScheme.outlineVariant,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 22),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: _GlassSocialButton(
                                          label: 'Google',
                                          icon: Icons.g_mobiledata,
                                          dark: dark,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _GlassSocialButton(
                                          label: 'Facebook',
                                          icon: Icons.facebook,
                                          dark: dark,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        'login.no_account'.tr(context),
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.goNamed(AppRoutes.signup);
                                        },
                                        child: Text(
                                          'login.sign_up'.tr(context),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          _GlassLanguageButton(
                            label: localization.currentLanguageName,
                            onPressed: localization.toggleLanguage,
                            dark: dark,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BACKGROUND
// ============================================================

class _GlassBackground extends StatelessWidget {
  const _GlassBackground();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: -100,
          left: -90,
          child: _GlowCircle(
            size: 300,
            color: dark ? const Color(0xFF087F5B) : const Color(0xFF71D9A0),
          ),
        ),
        Positioned(
          top: 180,
          right: -120,
          child: _GlowCircle(
            size: 280,
            color: dark ? const Color(0xFF234D8C) : const Color(0xFF9BC8F8),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -50,
          child: _GlowCircle(
            size: 300,
            color: dark ? const Color(0xFF155E75) : const Color(0xFFA4E6D2),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 65, sigmaY: 65),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

// ============================================================
// BRAND HEADER
// ============================================================

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: theme.colorScheme.primary.withValues(alpha: 0.13),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Iconsax.shop, size: 38, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'SHOPIZA',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your style, your shopping experience.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GLASS CARD
// ============================================================

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, required this.dark});

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: dark
                ? const Color(0xFF182438).withValues(alpha: 0.76)
                : Colors.white.withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.85),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.16 : 0.045),
                blurRadius: 35,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================
// GLASS TEXT FIELD
// ============================================================

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.dark,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.suffix,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool dark;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
            ),
            prefixIcon: Icon(icon, color: theme.colorScheme.primary, size: 21),
            suffixIcon: suffix,
            filled: true,
            fillColor: dark
                ? Colors.white.withValues(alpha: 0.055)
                : Colors.white.withValues(alpha: 0.48),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: dark
                    ? Colors.white.withValues(alpha: 0.13)
                    : Colors.white.withValues(alpha: 0.95),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.7,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GLASS LOGIN BUTTON
// ============================================================

class _GlassLoginButton extends StatelessWidget {
  const _GlassLoginButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(
          colors: [primary, Color.lerp(primary, Colors.black, 0.18)!],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.login, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'login.login'.tr(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ============================================================
// GLASS SOCIAL BUTTON
// ============================================================

class _GlassSocialButton extends StatelessWidget {
  const _GlassSocialButton({
    required this.label,
    required this.icon,
    required this.dark,
  });

  final String label;
  final IconData icon;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: dark
                ? Colors.white.withValues(alpha: 0.055)
                : Colors.white.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label sign-in is not configured yet.'),
                ),
              );
            },
            borderRadius: BorderRadius.circular(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 25),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
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

// ============================================================
// GLASS LANGUAGE BUTTON
// ============================================================

class _GlassLanguageButton extends StatelessWidget {
  const _GlassLanguageButton({
    required this.label,
    required this.onPressed,
    required this.dark,
  });

  final String label;
  final VoidCallback onPressed;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Iconsax.global, size: 19),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            backgroundColor: dark
                ? Colors.white.withValues(alpha: 0.055)
                : Colors.white.withValues(alpha: 0.4),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.65),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
