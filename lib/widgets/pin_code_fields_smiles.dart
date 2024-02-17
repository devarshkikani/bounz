import 'dart:async';
import 'dart:io';

import 'dart:math';

import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinCodeTextFieldSmiles extends StatefulWidget {
  final BuildContext appContext;

  final int length;

  final ValueChanged<String> onChanged;

  final ValueChanged<String>? onCompleted;

  final ValueChanged<String>? onSubmitted;

  final AnimationType animationType;

  final Duration animationDuration;

  final Curve animationCurve;

  final bool enabled;

  final TextEditingController? controller;

  final StreamController<ErrorAnimationType>? errorAnimationController;

  final bool Function(String? text)? beforeTextPaste;

  final Function? onTap;

  final FormFieldValidator<String>? validator;

  final FormFieldSetter<String>? onSaved;

  const PinCodeTextFieldSmiles({
    Key? key,
    required this.appContext,
    required this.length,
    this.controller,
    required this.onChanged,
    this.onCompleted,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.animationType = AnimationType.slide,
    this.onTap,
    this.enabled = true,
    this.onSubmitted,
    this.errorAnimationController,
    this.beforeTextPaste,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextFieldSmiles>
    with TickerProviderStateMixin {
  TextEditingController? _textEditingController;
  FocusNode? _focusNode;
  late List<String> _inputList;
  int _selectedIndex = 0;
  BorderRadius? borderRadius;
  late AnimationController _controller;

  late AnimationController _cursorController;

  StreamSubscription<ErrorAnimationType>? _errorAnimationSubscription;
  bool isInErrorMode = false;
  late Animation<Offset> _offsetAnimation;

  late Animation<double> _cursorAnimation;

  TextStyle get _textStyle =>
      AppTextStyle.regular16.copyWith(color: AppColors.whiteColor);

  TextStyle get _hintStyle => _textStyle.copyWith();

  @override
  void initState() {
    _assignController();
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      setState(() {});
    });
    _inputList = List<String>.filled(widget.length, "");

    _cursorController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _cursorAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _cursorController,
      curve: Curves.easeIn,
    ));
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(.1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    _cursorController.repeat();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    if (widget.errorAnimationController != null) {
      _errorAnimationSubscription =
          widget.errorAnimationController!.stream.listen((errorAnimation) {
        if (errorAnimation == ErrorAnimationType.shake) {
          _controller.forward();
          setState(() => isInErrorMode = true);
        }
      });
    }

    if (_textEditingController!.text.isNotEmpty) {
      _setTextToInput(_textEditingController!.text);
    }
    super.initState();
  }

  void _assignController() {
    if (widget.controller == null) {
      _textEditingController = TextEditingController();
    } else {
      _textEditingController = widget.controller;
    }

    _textEditingController?.addListener(() {
      if (isInErrorMode) {
        setState(() => isInErrorMode = false);
      }

      var currentText = _textEditingController!.text;

      if (widget.enabled && _inputList.join("") != currentText) {
        if (currentText.length >= widget.length) {
          if (widget.onCompleted != null) {
            if (currentText.length > widget.length) {
              currentText = currentText.substring(0, widget.length);
            }

            Future.delayed(const Duration(milliseconds: 300),
                () => widget.onCompleted!(currentText));
          }

          _focusNode!.unfocus();
        }
        widget.onChanged(currentText);
      }

      _setTextToInput(currentText);
    });
  }

  @override
  void dispose() {
    // _textEditingController!.dispose();
    _focusNode!.dispose();

    _errorAnimationSubscription?.cancel();

    _cursorController.dispose();

    _controller.dispose();
    super.dispose();
  }

  Widget _renderPinField({
    @required int? index,
  }) {
    assert(index != null);

    if (_inputList[index!].isEmpty) {
      return Text(
        '',
        key: ValueKey(_inputList[index]),
        style: _hintStyle,
      );
    }

    final text = _inputList[index];
    return Text(
      text,
      key: ValueKey(_inputList[index]),
      style: _textStyle,
    );
  }

  Widget buildChild(int index) {
    if (((_selectedIndex == index) ||
            (_selectedIndex == index + 1 && index + 1 == widget.length)) &&
        _focusNode!.hasFocus) {
      final cursorHeight = _textStyle.fontSize! + 8;

      if ((_selectedIndex == index + 1 && index + 1 == widget.length)) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: _textStyle.fontSize! / 1.5),
                child: FadeTransition(
                  opacity: _cursorAnimation,
                  child: CustomPaint(
                    size: Size(0, cursorHeight),
                    painter: CursorPainter(),
                  ),
                ),
              ),
            ),
            _renderPinField(
              index: index,
            ),
          ],
        );
      } else {
        return Center(
          child: FadeTransition(
            opacity: _cursorAnimation,
            child: CustomPaint(
              size: Size(0, cursorHeight),
              painter: CursorPainter(),
            ),
          ),
        );
      }
    }
    return _renderPinField(
      index: index,
    );
  }

  Future<void> _showPasteDialog(String pastedText) {
    final formattedPastedText = pastedText
        .trim()
        .substring(0, min(pastedText.trim().length, widget.length));

    final defaultPastedTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );

    return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: const Text("Paste Code"),
              content: RichText(
                text: TextSpan(
                  text: "Do you want to paste this code ",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge!.color,
                  ),
                  children: [
                    TextSpan(
                      text: formattedPastedText,
                      style: defaultPastedTextStyle,
                    ),
                    TextSpan(
                      text: "?",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelLarge!.color,
                      ),
                    )
                  ],
                ),
              ),
              actions: _getActionButtons(formattedPastedText),
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text("Paste Code"),
              content: RichText(
                text: TextSpan(
                  text: "Do you want to paste this code ",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.labelLarge!.color),
                  children: [
                    TextSpan(
                      text: formattedPastedText,
                      style: defaultPastedTextStyle,
                    ),
                    TextSpan(
                      text: " ?",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelLarge!.color,
                      ),
                    )
                  ],
                ),
              ),
              actions: _getActionButtons(formattedPastedText),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textField = TextFormField(
      textInputAction: TextInputAction.done,
      controller: _textEditingController,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofillHints: const <String>[AutofillHints.oneTimeCode],
      autofocus: true,
      autocorrect: false,
      keyboardType: TextInputType.number,
      // keyboardAppearance: widget.keyboardAppearance,
      textCapitalization: TextCapitalization.none,
      validator: widget.validator,
      onSaved: widget.onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        LengthLimitingTextInputFormatter(
          widget.length,
        ), // this limits the input length
      ],
      // trigger on the complete event handler from the keyboard
      onFieldSubmitted: widget.onSubmitted,
      enableInteractiveSelection: false,
      showCursor: false,
      // using same as background color so tha it can blend into the view
      cursorWidth: 0.01,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(0),
        border: InputBorder.none,
        fillColor: Colors.transparent,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      style: const TextStyle(
        color: Colors.transparent,
        height: .01,
        fontSize: kIsWeb
            ? 1
            : 0.01, // it is a hidden textfield which should remain transparent and extremely small
      ),
      scrollPadding: const EdgeInsets.all(20),
    );

    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            AbsorbPointer(
              absorbing: true,
              child: AutofillGroup(
                onDisposeAction: AutofillContextAction.commit,
                child: textField,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  if (widget.onTap != null) widget.onTap!();
                  _onFocus();
                },
                onLongPress: widget.enabled
                    ? () async {
                        var data = await Clipboard.getData("text/plain");
                        if (data?.text?.isNotEmpty ?? false) {
                          if (widget.beforeTextPaste != null) {
                            if (widget.beforeTextPaste!(data!.text)) {
                              _showPasteDialog(data.text!);
                            }
                          } else {
                            _showPasteDialog(data!.text!);
                          }
                        }
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _generateFields(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateFields() {
    var result = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      result.add(
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  // curve: widget.animationCurve,
                  // duration: widget.animationDuration,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: borderRadius,
                  ),
                  child: Center(
                    // child: AnimatedSwitcher(
                    //   switchInCurve: widget.animationCurve,
                    //   switchOutCurve: widget.animationCurve,
                    //   duration: widget.animationDuration,
                    //   transitionBuilder: (child, animation) {
                    //     if (widget.animationType == AnimationType.scale) {
                    //       return ScaleTransition(
                    //         scale: animation,
                    //         child: child,
                    //       );
                    //     } else if (widget.animationType == AnimationType.fade) {
                    //       return FadeTransition(
                    //         opacity: animation,
                    //         child: child,
                    //       );
                    //     } else if (widget.animationType == AnimationType.none) {
                    //       return child;
                    //     } else {
                    //       return SlideTransition(
                    //         position: Tween<Offset>(
                    //           begin: const Offset(0, .5),
                    //           end: Offset.zero,
                    //         ).animate(animation),
                    //         child: child,
                    //       );
                    //     }
                    //   },
                    child: buildChild(i),
                    // ),
                  ),
                ),
              ),
              if (widget.length != (i + 1))
                Container(
                  width: 1,
                  height: AppSizes.size20,
                  color: AppColors.whiteColor.withOpacity(0.2),
                ),
            ],
          ),
        ),
      );
    }
    return result;
  }

  void _onFocus() {
    if (_focusNode!.hasFocus &&
        MediaQuery.of(widget.appContext).viewInsets.bottom == 0) {
      _focusNode!.unfocus();
      Future.delayed(
          const Duration(microseconds: 1), () => _focusNode!.requestFocus());
    } else {
      _focusNode!.requestFocus();
    }
  }

  void _setTextToInput(String data) async {
    var replaceInputList = List<String>.filled(widget.length, "");

    for (int i = 0; i < widget.length; i++) {
      replaceInputList[i] = data.length > i ? data[i] : "";
    }

    if (mounted) {
      setState(() {
        _selectedIndex = data.length;
        _inputList = replaceInputList;
      });
    }
  }

  List<Widget> _getActionButtons(String pastedText) {
    var resultList = <Widget>[];
    if (Platform.isIOS) {
      resultList.addAll([
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        CupertinoDialogAction(
          child: const Text("Paste"),
          onPressed: () {
            _textEditingController!.text = pastedText;
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ]);
    } else {
      resultList.addAll([
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        TextButton(
          child: const Text("Paste"),
          onPressed: () {
            _textEditingController!.text = pastedText;
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ]);
    }
    return resultList;
  }
}

enum ErrorAnimationType { shake }

enum AnimationType { scale, slide, fade, none }

class CursorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(0, 0);
    final p2 = Offset(0, size.height);
    final paint = Paint()
      ..color = AppColors.whiteColor
      ..strokeWidth = 2;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
