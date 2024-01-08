import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rich_text_view/rich_text_view.dart';

/// Creates a [TextFormField] that shows suggestions mentioning and hashtags.
///
/// When [hashtagSuggestions] or [mentionSuggestions] is specified, the search as the user types will be performed on this list.
///
/// For displaying a rich text widget, see the [RichTextView] class
///
class RichTextEditor extends StatefulWidget {
  final String? initialValue;
  final int? maxLines;
  final TextAlign textAlign;
  final TextStyle? style;
  final bool autoFocus;
  final bool expands;
  final bool fromPost;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final Function(String)? onChanged;
  final int? maxLength;
  final int? minLines;
  final Color? suggestionColor;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool readOnly;
  final TextDirection? textDirection;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsetsGeometry padding;
  final EdgeInsets? paddingSuggestion;
  final EdgeInsets? margin;
  final double radius;

  ///A controller for the suggestion behaviour and customisations.
  /// You can as well extend this controller for a more custom behaviour.
  final SuggestionController? suggestionController;

  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  final TextInputAction? textInputAction;
  final double horizontalPadding;
  final double verticalPadding;
  final double leftPadding;
  final bool isImage;
  const RichTextEditor(
      {Key? key,
      this.initialValue,
      this.maxLines,
      this.textAlign = TextAlign.start,
      this.style,
      this.controller,
      this.decoration,
      this.onChanged,
      this.textInputType = TextInputType.text,
      this.autoFocus = false,
      this.fromPost = false,
      this.maxLength,
      this.minLines,
      this.keyboardType,
      this.focusNode,
      this.suggestionColor,
      this.readOnly = false,
      this.expands = false,
      this.suggestionController,
      this.backgroundColor = Colors.white,
      this.textInputAction,
      this.textDirection,
      this.paddingSuggestion,
      this.margin,
      this.radius = 20,
      this.onEditingComplete,
      this.inputFormatters,
      this.textAlignVertical,
      this.onFieldSubmitted,
      this.onSaved,
      this.validator,
        this.horizontalPadding = 20,
        this.verticalPadding = 10,
        this.leftPadding = 10,
        this.isImage = true,
      this.padding = const EdgeInsets.only(top: 16.0)})
      : super(key: key);

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late TextEditingController controller;
  late SuggestionController suggestionController;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
    suggestionController =
        (widget.suggestionController ?? SuggestionController())
          ..addListener(() {
            setState(() {});
          });
  }
  //
  // @override
  // void dispose() {
  //   controller.dispose();
  //   suggestionController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var searchItemWidget = SearchItemWidget(
          suggestionController: suggestionController,
          controller: controller,
          backgroundColor: widget.backgroundColor,
          suggestionColor: widget.suggestionColor,
          padding: widget.paddingSuggestion,
          margin: widget.margin,
          radius: widget.radius,
          horizontalPadding: widget.horizontalPadding,
          verticalPadding: widget.verticalPadding,
          leftPadding: widget.leftPadding,
          isImage: widget.isImage,
          onTap: (contrl) {
            setState(() {
              controller = contrl;
            });
          });
      return Padding(
        padding: widget.padding,
        child: widget.fromPost == true
            ? widget.maxLines == 8
                ? Stack(
                    children: [
                      TextFormField(
                        style: widget.style,
                        expands: widget.expands,
                        focusNode: widget.focusNode,
                        controller: controller,
                        textCapitalization: TextCapitalization.sentences,
                        readOnly: widget.readOnly,
                        textDirection: widget.textDirection,
                        textInputAction: widget.textInputAction,
                        onChanged: (val) async {
                          widget.onChanged?.call(val);
                          suggestionController
                              .onChanged(val.split(' ').last.toLowerCase());
                        },
                        maxLines: widget.maxLines,
                        keyboardType: widget.keyboardType,
                        maxLength: widget.maxLength,
                        minLines: widget.minLines,
                        autofocus: widget.autoFocus,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: widget.decoration,
                        textAlign: widget.textAlign,
                        onFieldSubmitted: widget.onFieldSubmitted,
                        inputFormatters: widget.inputFormatters,
                        textAlignVertical: widget.textAlignVertical,
                        onEditingComplete: widget.onEditingComplete,
                        validator: widget.validator,
                        onSaved: widget.onSaved,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: kToolbarHeight),
                        child: searchItemWidget,
                      )
                    ],
                  )
                : Column(
                    children: [
                      TextFormField(
                        style: widget.style,
                        expands: widget.expands,
                        focusNode: widget.focusNode,
                        controller: controller,
                        textCapitalization: TextCapitalization.sentences,
                        readOnly: widget.readOnly,
                        textDirection: widget.textDirection,
                        textInputAction: widget.textInputAction,
                        onChanged: (val) async {
                          widget.onChanged?.call(val);
                          suggestionController
                              .onChanged(val.split(' ').last.toLowerCase());
                        },
                        maxLines: widget.maxLines,
                        keyboardType: widget.keyboardType,
                        maxLength: widget.maxLength,
                        minLines: widget.minLines,
                        autofocus: widget.autoFocus,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: widget.decoration,
                        textAlign: widget.textAlign,
                        onFieldSubmitted: widget.onFieldSubmitted,
                        inputFormatters: widget.inputFormatters,
                        textAlignVertical: widget.textAlignVertical,
                        onEditingComplete: widget.onEditingComplete,
                        validator: widget.validator,
                        onSaved: widget.onSaved,
                      ),
                      searchItemWidget
                    ],
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (suggestionController.position == SuggestionPosition.top)
                    searchItemWidget,
                  TextFormField(
                    style: widget.style,
                    expands: widget.expands,
                    focusNode: widget.focusNode,
                    controller: controller,
                    textCapitalization: TextCapitalization.sentences,
                    readOnly: widget.readOnly,
                    textDirection: widget.textDirection,
                    textInputAction: widget.textInputAction,
                    onChanged: (val) async {
                      widget.onChanged?.call(val);
                      suggestionController
                          .onChanged(val.split(' ').last.toLowerCase());
                    },
                    maxLines: widget.maxLines,
                    keyboardType: widget.keyboardType,
                    maxLength: widget.maxLength,
                    minLines: widget.minLines,
                    autofocus: widget.autoFocus,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: widget.decoration,
                    textAlign: widget.textAlign,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    inputFormatters: widget.inputFormatters,
                    textAlignVertical: widget.textAlignVertical,
                    onEditingComplete: widget.onEditingComplete,
                    validator: widget.validator,
                    onSaved: widget.onSaved,
                  ),
                  if (suggestionController.position ==
                      SuggestionPosition.bottom)
                    searchItemWidget,
                ],
              ),
      );
    });
  }
}
