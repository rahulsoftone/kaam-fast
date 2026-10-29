import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class CustomPinInput extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final double boxWidth;
  final double boxHeight;

  const CustomPinInput({
    super.key,
    this.length = 4,
    required this.controller,
    this.onCompleted,
    this.autofocus = true,
    this.boxWidth = 52,
    this.boxHeight = 56,
  });

  @override
  State<CustomPinInput> createState() => _CustomPinInputState();
}

class _CustomPinInputState extends State<CustomPinInput> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onTextChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
    if (widget.controller.text.length == widget.length) {
      widget.onCompleted?.call(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Invisible actual text field capturing keyboard input
          Opacity(
            opacity: 0.0,
            child: SizedBox(
              width: 1,
              height: 1,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                autofocus: widget.autofocus,
                showCursor: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Visual PIN Boxes Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.length, (index) {
              final isFilled = index < text.length;
              final isCurrent = index == text.length && _focusNode.hasFocus;
              final char = isFilled ? text[index] : '';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: widget.boxWidth,
                height: widget.boxHeight,
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrent
                        ? primary
                        : (isFilled ? primary.withValues(alpha: 0.8) : darkBorder),
                    width: isCurrent || isFilled ? 2.0 : 1.2,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.35),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  char,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
