import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../util/theme/text.styles.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final int? maxLines;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowSuffixWidget;
  final Widget? suffixWidget;
  final bool? isShowPrefixIcon;
  final VoidCallback? onTap;
  final VoidCallback? onChanged;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool? isSearchStudent;
  final VoidCallback? onSubmit;
  final bool? isEnabled;
  final double? hintFontSize;
  final TextCapitalization? capitalization;
  final double? horizontalSize;
  final double? verticalSize;
  final double? borderRadius;
  final bool? autoFocus;
  final bool? isSaveAutoFillData;
  final String autoFillHints;
  final String labelText;

  const CustomTextField(
      {this.hintText = 'Write something...',
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.hintFontSize = 13,
      this.onSuffixTap,
      this.fillColor,
      this.onSubmit,
      this.onChanged,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      this.suffixIconUrl,
      this.isShowSuffixWidget = false,
      this.suffixWidget,
      this.prefixIconUrl = '',
      this.labelText = '',
      this.autoFillHints = AutofillHints.name,
      this.isSearchStudent = false,
      this.autoFocus = false,
      this.isSaveAutoFillData = false,
      this.horizontalSize = 22,
      this.verticalSize = 10,
      this.borderRadius = 20,
      Key? key})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.fillColor ?? const Color.fromRGBO(245, 246, 248, 1),
        boxShadow: [
          BoxShadow(
              color: AppColors.primaryColorLight.withOpacity(.1), offset: const Offset(0, 0), blurRadius: 20, spreadRadius: 3)
        ],
        borderRadius: BorderRadius.circular(widget.borderRadius!),
      ),
      child: TextFormField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        onEditingComplete: () {
          if (widget.isSaveAutoFillData!) TextInput.finishAutofillContext();
        },

        autofillHints: const [AutofillHints.newPassword],
        style: headline4.copyWith(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 16),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: AppColors.primaryColorLight,
        textCapitalization: widget.capitalization!,
        enabled: widget.isEnabled,
        autofocus: widget.autoFocus!,
        //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
        obscureText: widget.isPassword! ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone
            ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
            : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: widget.verticalSize!, horizontal: widget.horizontalSize!),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent,
                  width: widget.isShowBorder! ? 1 : 0)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent,
                  width: widget.isShowBorder! ? 1 : 0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent,
                  width: widget.isShowBorder! ? 1 : 0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent,
                  width: widget.isShowBorder! ? 1 : 1)),
          isDense: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          fillColor: widget.fillColor ?? const Color.fromRGBO(245, 246, 248, 1),
          hintStyle: input.copyWith(fontSize: widget.hintFontSize, color: Colors.grey[500]),
          filled: true,
          prefixIcon: widget.isShowPrefixIcon!
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Image.asset(widget.prefixIconUrl!),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
          //suffix: widget.isShowSuffixWidget! ? widget.suffixWidget : SizedBox.shrink(),
          suffixIcon: widget.isShowSuffixIcon! && !widget.isShowSuffixWidget!
              ? widget.isPassword!
                  ? IconButton(
                      icon: Icon(!_obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.grey, size: 23),
                      onPressed: _toggle)
                  : widget.isIcon!
                      ? IconButton(
                          onPressed: widget.onSuffixTap,
                          icon: Image.asset(widget.suffixIconUrl!,
                              width: 15, height: 15, color: Theme.of(context).textTheme.bodyText1!.color))
                      : null
              : widget.isShowSuffixWidget!
                  ? widget.suffixWidget
                  : null,
        ),
        onFieldSubmitted: (String? text) =>
            widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : widget.onSubmit!(),
        onChanged: (String? value) {
          if (widget.isSearchStudent!) {
            Provider.of<StudentProvider>(context, listen: false).searchStudent(value!);
          }

        },
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
