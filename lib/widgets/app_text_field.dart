import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Text field with gold glow focus effect.
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focus = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() => _isFocused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: _isFocused ? AppTheme.goldAccent : AppTheme.creamWhite.withValues(alpha: 0.55),
          ),
          child: Text(widget.label.toUpperCase()),
        ),
        const SizedBox(height: 8),

        // Input with animated gold glow on focus
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.goldAccent.withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            obscureText: widget.isPassword,
            keyboardType: widget.keyboardType,
            style: const TextStyle(
              color: AppTheme.creamWhite,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: AppTheme.creamWhite.withValues(alpha: 0.3)),
              prefixIcon: widget.icon != null
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        widget.icon,
                        key: ValueKey(_isFocused),
                        color: _isFocused
                            ? AppTheme.goldAccent
                            : AppTheme.creamWhite.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: AppTheme.navyDeep,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.goldAccent, width: 1.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
