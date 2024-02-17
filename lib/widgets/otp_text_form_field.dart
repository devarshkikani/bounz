import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
// ignore_for_file: must_be_immutable

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers = void Function(
    List<TextEditingController?> controllers);

class OtpTextField extends StatefulWidget {
  final int numberOfFields;
  final OnCodeEnteredCompletion? onSubmit;
  final OnCodeEnteredCompletion? onCodeChanged;
  final HandleControllers? handleControllers;
  bool clearText;

  OtpTextField({
    super.key,
    this.numberOfFields = 5,
    this.clearText = false,
    this.handleControllers,
    this.onSubmit,
    this.onCodeChanged,
  }) : assert(numberOfFields > 0);

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<String?> _verificationCode;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  @override
  void initState() {
    super.initState();

    _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    _focusNodes = List<FocusNode?>.filled(widget.numberOfFields, null);
    _textControllers = List<TextEditingController?>.filled(
      widget.numberOfFields,
      null,
    );
  }

  @override
  void didUpdateWidget(covariant OtpTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clearText != widget.clearText && widget.clearText == true) {
      for (var controller in _textControllers) {
        controller?.clear();
      }
      _verificationCode = List<String?>.filled(widget.numberOfFields, null);
      setState(() {
        widget.clearText = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _textControllers) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateTextFields(context);
  }

  Widget _buildTextField({
    required BuildContext context,
    required int index,
    TextStyle? style,
  }) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 1,
              style: style ??
                  AppTextStyle.regular16.copyWith(color: AppColors.whiteColor),
              keyboardType: TextInputType.number,
              autofocus: true,
              obscureText: true,
              cursorColor: AppColors.whiteColor,
              controller: _textControllers[index],
              focusNode: _focusNodes[index],
              autofillHints: const [AutofillHints.oneTimeCode],
              decoration: const InputDecoration(
                counterText: "",
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                disabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              onChanged: (String value) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  changeFocusToNextNodeWhenValueIsEntered(
                      value: value, indexOfTextField: index);
                  changeFocusToPreviousNodeWhenValueIsRemoved(
                      value: value, indexOfTextField: index);
                  onCodeChanged(verificationCode: value);
                  _verificationCode[index] = value;
                  onSubmit(verificationCode: _verificationCode);
                });
              },
            ),
          ),
          if (widget.numberOfFields != (index + 1))
            Container(
              width: 1,
              height: AppSizes.size20,
              color: AppColors.whiteColor.withOpacity(0.2),
            ),
        ],
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.numberOfFields, (int i) {
      addFocusNodeToEachTextField(index: i);
      addTextEditingControllerToEachTextField(index: i);
      if (widget.handleControllers != null) {
        widget.handleControllers!(_textControllers);
      }
      return _buildTextField(context: context, index: i);
    });

    return Container(
      height: AppSizes.size54 + 1,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(58, 33, 57, 0.23),
            Color.fromRGBO(22, 9, 19, 0.23),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: textFields,
      ),
    );
  }

  void addFocusNodeToEachTextField({required int index}) {
    if (_focusNodes[index] == null) {
      _focusNodes[index] = FocusNode();
    }
  }

  void addTextEditingControllerToEachTextField({required int index}) {
    if (_textControllers[index] == null) {
      _textControllers[index] = TextEditingController();
    }
  }

  void changeFocusToNextNodeWhenValueIsEntered({
    required String value,
    required int indexOfTextField,
  }) {
    if (value.isNotEmpty) {
      if (indexOfTextField + 1 != widget.numberOfFields) {
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField + 1]);
      } else {
        _focusNodes[indexOfTextField]?.unfocus();
      }
    }
  }

  void changeFocusToPreviousNodeWhenValueIsRemoved({
    required String value,
    required int indexOfTextField,
  }) {
    if (value.isEmpty) {
      if (indexOfTextField != 0) {
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField - 1]);
      }
    }
  }

  void onSubmit({required List<String?> verificationCode}) {
    if (widget.onSubmit != null) {
      widget.onSubmit!(verificationCode.join());
    }
  }

  void onCodeChanged({required String verificationCode}) {
    if (widget.onCodeChanged != null) {
      widget.onCodeChanged!(verificationCode);
    }
  }
}
