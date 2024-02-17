import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/widgets/app_text_form_field.dart';

class EmailWidget extends StatelessWidget {
  const EmailWidget({
    Key? key,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.style,
    this.controller,
    this.textInputAction,
    this.keyboardType,
    this.enabled,
    this.readOnly,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.borderSide,
    this.suffixIcon,
    this.onChanged,
  }) : super(key: key);
  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? enabled;
  final bool? readOnly;
  final FormFieldValidator<String?>? validator;
  final BorderSide? borderSide;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Function(String? value)? onFieldSubmitted;
  final Function(String? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      fieldKey: fieldKey,
      hintText: hintText,
      focusNode: focusNode,
      controller: controller,
      labelText: labelText,
      enabled: enabled,
      readOnly: readOnly,
      suffixIcon: suffixIcon,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      validator: validator ??
          (String? value) => Validators.validateEmail(value!.trim()),
    );
  }
}

// ignore: must_be_immutable
class PasswordWidget extends StatefulWidget {
  PasswordWidget({
    Key? key,
    this.fieldKey,
    this.labelText,
    required this.passType,
    this.hintText,
    this.validator,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.showsuffixIcon,
    this.borderSide,
    this.onChaged,
    this.onFieldSubmitted,
  }) : super(key: key);

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String passType;
  final FormFieldValidator<String?>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final BorderSide? borderSide;
  final Function(String? value)? onFieldSubmitted;
  final Function(String? value)? onChaged;
  bool? showsuffixIcon = true;

  @override
  PasswordWidgetState createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      fieldKey: widget.fieldKey,
      hintText: widget.hintText,
      border: widget.borderSide,
      labelText: widget.labelText,
      focusBorder: widget.borderSide,
      enabledBorder: widget.borderSide,
      focusNode: widget.focusNode,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: TextInputType.emailAddress,
      onChanged: widget.onChaged,
      validator: widget.validator ??
          (String? value) => Validators.validatePassword(
                value!.trim(),
                widget.passType,
              ),
      suffixIcon: widget.showsuffixIcon == true
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textFieldColor,
              ),
            )
          : const SizedBox(),
    );
  }
}

class NumberWidget extends StatelessWidget {
  const NumberWidget({
    Key? key,
    this.fieldKey,
    this.onChanged,
    this.readOnly,
    this.hintText,
    this.labelText,
    this.validator,
    this.controller,
    this.maxLength,
    this.focusNode,
    this.autofocus,
    this.style,
    this.prefixIconConstraints,
    this.textInputAction,
    this.prefixIcon,
    this.textAlign = TextAlign.left,
    this.inputFormatters,
    this.contentPadding,
    this.keyboardType,
    this.fillColor,
    this.suffixIcon,
    this.onTap,
    this.enabled,
    this.hintStyle,
  }) : super(key: key);

  final Key? fieldKey;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String?>? validator;
  final TextEditingController? controller;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? readOnly;
  final bool? enabled;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final ValueChanged<String?>? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      hintStyle: hintStyle,
      keyboardType: keyboardType ?? TextInputType.phone,
      suffixIcon: suffixIcon,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      fieldKey: fieldKey,
      hintText: hintText,
      focusNode: focusNode,
      controller: controller,
      style: style,
      filledColor: fillColor,
      validator: validator,
      textAlign: textAlign,
      maxLength: maxLength,
      labelText: labelText,
      prefixIcon: prefixIcon,
      enabled: enabled,
      prefixIconConstraints: prefixIconConstraints,
      textInputAction: textInputAction ?? TextInputAction.done,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      inputFormatters: inputFormatters ??
          <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]'))
          ],
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    Key? key,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.validator,
    this.prefixIcon,
    this.controller,
    this.obscureText,
    this.focusNode,
    this.maxLines,
    this.maxLength,
    this.suffixIcon,
    this.onTap,
    this.cursorHeight,
    this.enabled,
    this.readOnly,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.textInputAction,
    this.keyboardType,
    this.filledColor,
    this.hintStyle,
    this.style,
    this.focusBorder,
    this.border,
    this.enabledBorder,
    this.cursorColor,
    this.contentPadding,
    this.autofocus,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.textCapitalization = TextCapitalization.words,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final bool? readOnly;
  final bool? obscureText;
  final double? cursorHeight;
  final FormFieldValidator<String?>? validator;
  final ValueChanged<String?>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String?>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final bool? enabled;
  final bool? autofocus;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final Color? filledColor;
  final Color? cursorColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final BorderSide? focusBorder;
  final BorderSide? border;
  final BorderSide? enabledBorder;
  final EdgeInsetsGeometry? contentPadding;
  final TextCapitalization textCapitalization;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;

  @override
  Widget build(BuildContext context) {
    return textFormField(
      fieldKey: fieldKey,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      hintText: hintText,
      style: style,
      obscureText: obscureText,
      readOnly: readOnly,
      textCapitalization: textCapitalization,
      labelText: labelText,
      inputFormatters: inputFormatters,
      hintStyle: hintStyle,
      controller: controller,
      cursorColor: cursorColor ?? AppColors.whiteColor,
      keyboardType: keyboardType,
      validator: validator,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction: textInputAction,
      textAlign: textAlign,
      cursorHeight: cursorHeight,
      onTap: onTap,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      contentPadding: contentPadding,
      filledColor: filledColor,
      border: border,
      prefixIconConstraints: prefixIconConstraints,
      suffixIconConstraints: suffixIconConstraints,
      focusBorder: focusBorder,
      enabledBorder: enabledBorder,
    );
  }
}
