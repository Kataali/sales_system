import 'package:fluent_ui/fluent_ui.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final int minLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final EdgeInsetsGeometry contentPadding;
  final bool enabled;
  final bool readOnly;


  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    this.enabled = true,
    this.readOnly = false,
  });


  @override
  Widget build(BuildContext context) {
    Widget box = TextFormBox(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      textInputAction: textInputAction,
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      placeholder: hint ?? label,

      prefix: prefixIcon != null ? Padding(padding: const EdgeInsetsDirectional.only(start: 8.0, end: 4.0), child: prefixIcon) : null,
      suffix: suffixIcon != null ? Padding(padding: const EdgeInsetsDirectional.only(end: 8.0, start: 4.0), child: suffixIcon) : null,
      padding: contentPadding,
    );
    
    if (label != null) {
      return InfoLabel(
        label: label!,
        child: box,
      );
    }
    return box;
  }
}



