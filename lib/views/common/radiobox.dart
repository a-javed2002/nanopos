import 'package:flutter/material.dart';

class CustomRadioBox extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Function(bool) onSelect;

  CustomRadioBox({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  _CustomRadioBoxState createState() => _CustomRadioBoxState();
}

class _CustomRadioBoxState extends State<CustomRadioBox> {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.isSelected);
        widget.onSelect(!widget.isSelected);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.isSelected ? Colors.blue.withOpacity(0.5) : Colors.transparent,
          border: Border.all(
            color: widget.isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
