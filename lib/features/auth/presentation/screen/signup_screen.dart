import 'dart:ui';
import 'package:ecom_app/app/routes/app_routes.dart';
import 'package:ecom_app/core/localization/translate_extension.dart';
import 'package:ecom_app/core/responsive/app_breakpoints.dart';
import 'package:ecom_app/features/auth/presentation/providers/signup_provider.dart';
import 'package:ecom_app/features/auth/presentation/validators/signup_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignupProvider>();
    final validator = SignupValidator();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF101827) : const Color(0xFFF0F5F2),
      body: Stack(
        children: [
          const Positioned.fill(child: _SignupBackground()),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isMobile = AppBreakpoints.isMobile(width);
              final isTablet = AppBreakpoints.isTablet(width);

              final horizontalPadding = isMobile
                  ? 20.0
                  : isTablet
                  ? 32.0
                  : 40.0;

              final maxWidth = isMobile
                  ? 560.0
                  : isTablet
                  ? 560.0
                  : 520.0;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isMobile ? 20 : 32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // HEADER
                        const _SignupHeader(),

                        SizedBox(height: isMobile ? 24 : 32),

                        // GLASS FORM CARD
                        _SignupGlassCard(
                          dark: dark,
                          child: Form(
                            key: provider.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Join Shopiza and start shopping today.',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // USERNAME
                                _GlassSignupField(
                                  label: 'signup.username'.tr(context),
                                  hint: 'signup.username_hint'.tr(context),
                                  controller: provider.nameController,
                                  icon: Iconsax.user,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  validator: validator.validateName,
                                  dark: dark,
                                  onClear: () {
                                    provider.nameController.clear();
                                  },
                                ),

                                const SizedBox(height: 20),

                                // EMAIL
                                _GlassSignupField(
                                  label: 'signup.email'.tr(context),
                                  hint: 'signup.email_hint'.tr(context),
                                  controller: provider.emailController,
                                  icon: Iconsax.sms,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: validator.validateEmail,
                                  dark: dark,
                                  onClear: () {
                                    provider.emailController.clear();
                                  },
                                ),

                                const SizedBox(height: 20),

                                // PASSWORD
                                _GlassSignupField(
                                  label: 'signup.password'.tr(context),
                                  hint: 'signup.password_hint'.tr(context),
                                  controller: provider.passwordController,
                                  icon: Iconsax.lock,
                                  obscureText: provider.isPasswordVisible,
                                  textInputAction: TextInputAction.next,
                                  validator: validator.validatePassword,
                                  dark: dark,
                                  suffix: IconButton(
                                    tooltip: provider.isPasswordVisible
                                        ? 'Hide password'
                                        : 'Show password',
                                    onPressed:
                                        provider.togglePasswordVisibility,
                                    icon: Icon(
                                      provider.isPasswordVisible
                                          ? Iconsax.eye_slash
                                          : Iconsax.eye,
                                      color: colors.primary,
                                      size: 21,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // CONFIRM PASSWORD
                                _GlassSignupField(
                                  label: 'signup.confirm_password'.tr(context),
                                  hint: 'signup.confirm_password_hint'.tr(
                                    context,
                                  ),
                                  controller:
                                      provider.passwordConfirmationController,
                                  icon: Iconsax.password_check,
                                  obscureText:
                                      provider.isPasswordConfirmationVisible,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    return validator
                                        .validatePasswordConfirmation(
                                          value,
                                          provider.passwordController.text,
                                        );
                                  },
                                  dark: dark,
                                  suffix: IconButton(
                                    tooltip:
                                        provider.isPasswordConfirmationVisible
                                        ? 'Hide password'
                                        : 'Show password',
                                    onPressed: provider
                                        .toggleConfirmPasswordVisibility,
                                    icon: Icon(
                                      provider.isPasswordConfirmationVisible
                                          ? Iconsax.eye_slash
                                          : Iconsax.eye,
                                      color: colors.primary,
                                      size: 21,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // CREATE ACCOUNT BUTTON
                                _GlassSignupButton(
                                  title: provider.isLoading
                                      ? 'Creating account...'
                                      : 'signup.submit'.tr(context),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();

                                    if (provider.isLoading) return;

                                    final success = await provider.signup();

                                    if (!context.mounted) return;

                                    if (!success) {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              provider.errorMessage ??
                                                  'Please check your information and try again.',
                                            ),
                                            backgroundColor: colors.error,
                                          ),
                                        );
                                      return;
                                    }

                                    final needsEmailConfirmation =
                                        provider.requiresEmailConfirmation;

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            needsEmailConfirmation
                                                ? 'Account created! Please verify your email before logging in.'
                                                : 'Account created successfully!',
                                          ),
                                          backgroundColor: colors.primary,
                                          duration: const Duration(seconds: 4),
                                        ),
                                      );

                                    context.goNamed(AppRoutes.layout);
                                    // if (needsEmailConfirmation) {

                                    // }
                                  },
                                ),

                                const SizedBox(height: 28),

                                // DIVIDER
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: colors.outlineVariant,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        'signup.or_continue_with'.tr(context),
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: colors.outlineVariant,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                // SOCIAL BUTTONS
                                Row(
                                  children: [
                                    Expanded(
                                      child: _GlassSocialButton(
                                        title: 'signup.google'.tr(context),
                                        icon: Icons.g_mobiledata,
                                        dark: dark,
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Google sign-in is not '
                                                'configured yet.',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _GlassSocialButton(
                                        title: 'signup.facebook'.tr(context),
                                        icon: Icons.facebook,
                                        dark: dark,
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Facebook sign-in is not '
                                                'configured yet.',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // LOGIN NAVIGATION
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'signup.already_account'.tr(context),
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.goNamed(AppRoutes.login);
                                      },
                                      child: Text(
                                        'signup.login'.tr(context),
                                        style: TextStyle(
                                          color: colors.primary,
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

                        const SizedBox(height: 24),

                        // FOOTER
                        Center(
                          child: Text(
                            'Shopiza • Your shopping experience',
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GLASS BACKGROUND
// ============================================================

class _SignupBackground extends StatelessWidget {
  const _SignupBackground();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: -100,
          left: -100,
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
          color: color.withValues(alpha: 0.75),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: colors.primary.withValues(alpha: 0.13),
            border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.12),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Iconsax.shop, size: 38, color: colors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'SHOPIZA',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your account and discover more.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GLASS CARD
// ============================================================

class _SignupGlassCard extends StatelessWidget {
  const _SignupGlassCard({required this.child, required this.dark});

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

class _GlassSignupField extends StatelessWidget {
  const _GlassSignupField({
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
    this.onClear,
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
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
              color: colors.onSurfaceVariant.withValues(alpha: 0.75),
            ),
            prefixIcon: Icon(icon, color: colors.primary, size: 21),
            suffixIcon:
                suffix ??
                (onClear == null
                    ? null
                    : IconButton(
                        tooltip: 'Clear $label',
                        onPressed: onClear,
                        icon: Icon(
                          Iconsax.close_circle,
                          color: colors.onSurfaceVariant,
                          size: 19,
                        ),
                      )),
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
                color: colors.outlineVariant.withValues(alpha: 0.5),
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
              borderSide: BorderSide(color: colors.primary, width: 1.7),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: colors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GLASS SIGNUP BUTTON
// ============================================================

class _GlassSignupButton extends StatelessWidget {
  const _GlassSignupButton({required this.title, required this.onPressed});

  final String title;
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.user_add, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
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
    required this.title,
    required this.icon,
    required this.dark,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final bool dark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              color: colors.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 25),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    title,
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
