import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchTextField({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (query) {
        setState(() {});
        widget.onChanged(query);
      },
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                  widget.onClear();
                },
              )
            : null,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
