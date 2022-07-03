import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final styleActive = TextStyle(color: Color.fromARGB(255, 255, 255, 255));
    // final styleHint = TextStyle(color: Color.fromARGB(137, 255, 255, 255));
    // final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(255, 37, 37, 37),
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, 
                  ),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          // hintStyle: style,
          border: InputBorder.none,
        ),
        // style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}