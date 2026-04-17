import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.leadingHeroIcon,
    this.suffixHeroIcon,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLines =1
  });

  // Core
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final AutovalidateMode autovalidateMode;

  // UI
  final String? label;
  final String? hint;

  // Icons (Heroicons)
  final HeroIcons? leadingHeroIcon;
  final HeroIcons? suffixHeroIcon;

  // Behavior
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // لا نحدد أي حدود/ألوان هنا — نتركها للـ inputDecorationTheme
    final decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,

      // أيقونة البداية (prefix)
      prefixIcon: widget.leadingHeroIcon != null
          ? Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0, end: 4.0),
              child: HeroIcon(widget.leadingHeroIcon!, size: 22),
            )
          : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

      // أيقونة النهاية (suffix): توغل الباسوورد أو أيقونة ثابتة
      suffixIcon: widget.isPassword
          ? IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: HeroIcon(
                !_obscure ? HeroIcons.eye : HeroIcons.eyeSlash,
                size: 22,
              ),
              tooltip: _obscure ? 'إظهار' : 'إخفاء',
            )
          : (widget.suffixHeroIcon != null
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 4.0,
                      end: 8.0,
                    ),
                    child: HeroIcon(widget.suffixHeroIcon!, size: 22),
                  )
                : null),
    );

    return TextFormField(
      controller: widget.controller,
      style: Theme.of(context).textTheme.bodySmall,
      validator: widget.validator,
   
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscure,
      maxLines: widget.maxLines,
      decoration: decoration,
    );
  }
}
