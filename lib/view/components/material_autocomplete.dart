import 'package:flutter/material.dart';

class MaterialAutocomplete<T extends Object> extends Autocomplete<T> {
  final String labelText;

  MaterialAutocomplete(
      {Key? key,
      AutocompleteOnSelected<T>? onSelected,
      required AutocompleteOptionsBuilder<T> optionsBuilder,
      required this.labelText})
      : super(key: key, optionsBuilder: optionsBuilder, onSelected: onSelected);

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      onSelected: this.onSelected,
      fieldViewBuilder: ((BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) =>
          TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
            decoration: InputDecoration(
              labelText: this.labelText,
              border: OutlineInputBorder(),
            ),
          )),
      optionsBuilder: this.optionsBuilder,
    );
  }
}
