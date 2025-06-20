import 'package:flutter/material.dart';
import 'package:ysr_project/features/leaderborad/leaderboard_notifier.dart';

class SegmentedToggle extends StatefulWidget {
  final Function(Types) onSelectionChanged;

  const SegmentedToggle({super.key, required this.onSelectionChanged});

  @override
  State<SegmentedToggle> createState() => _SegmentedToggleState();
}

class _SegmentedToggleState extends State<SegmentedToggle> {
  final List<Types> options = [Types.state, Types.parliament, Types.assembly];
  Types selected = Types.parliament;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final bool isSelected = selected == option;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selected = option;
                });
                widget.onSelectionChanged(option);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.indigoAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: Text(
                  option.description,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
