import 'package:flutter/material.dart';
import 'package:nanopos/consts/consts.dart';

class TableStatus extends StatefulWidget {
  const TableStatus({Key? key}): super(key: key);
  @override
  TableStatusState createState() => TableStatusState();
}

class TableStatusState extends State<TableStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

   @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _colorAnimation = ColorTween(begin: Colors.red, end: Colors.yellow)
        .animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> table = {
      'name': 'Table 1',
      'size': 4,
      'is_calling': true, // Change this value to see the animation
      'isActive': false,
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: table['is_calling'] ? (_colorAnimation).value : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  table['name'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: table['is_calling']
                        ? whiteColor
                        : table['isActive']
                            ? whiteColor
                            : const Color(0xfff3b98a),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${table['size']} Persons",
                  style: TextStyle(
                    fontSize: 10,
                    color: table['is_calling']
                        ? whiteColor
                        : table['isActive']
                            ? whiteColor
                            : const Color(0xfff3b98a),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
