import 'package:flutter/material.dart';

class StyledSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool autofocus;

  const StyledSearchTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      cursorHeight: 16,
      cursorColor: Theme.of(context).secondaryHeaderColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search',
        prefixIcon: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(left: 8),
          child: Center(child: Icon(Icons.search_rounded)),
        ),
        suffixIcon: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final bool isEmpty = controller.text.isEmpty;

            if (isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: Icon(Icons.clear_rounded),
              iconSize: 20,
              onPressed: () {
                controller.clear();
                onChanged?.call('');
              },
            );
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 4),
        hintStyle: TextStyle(
          fontSize: 16,
          height: 24 / 16,
          color: Colors.black54,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}
