import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ysr_project/colors/app_colors.dart';

class PollWidget extends StatelessWidget {
  final List<int> votes;
  final bool enableSubmit;
  final String title;
  final String question;
  final List<String> options;
  final String? selectedOption;
  final Function(String) onOptionSelected;
  final DateTime createdAt;
  final void Function() onSubmit;

  const PollWidget({
    required this.votes,
    required this.enableSubmit,
    required this.onSubmit,
    required this.createdAt,
    super.key,
    required this.title,
    required this.question,
    required this.options,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> optionWidgets = [];

    for (int i = 0; i < options.length; i++) {
      optionWidgets.add(_buildOption(options[i], i));
    }
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...optionWidgets,
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSubmitButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
              AssetImage("assets/ysrcp_logo3.png"), // Change as needed
          radius: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        const Spacer(),
        Text(
          DateFormat("MMMM d, y").format(createdAt),
          style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildOption(String option, int index) {
    final bool isSelected = selectedOption == option;
    final bool isDisabled = !enableSubmit;

    return GestureDetector(
      onTap: isDisabled ? null : () => onOptionSelected(option),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green[100] // Selected background
              : isDisabled
                  ? Colors.grey[100] // Already selected + disabled
                  : Colors.white, // Unselected
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.green[100]!
                : Colors.grey[300]!, // Light border for others
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? Color(0xFF25721E)
                  : isDisabled
                      ? Colors.grey
                      : Color(0xFF25721E), // Grey if disabled
            ),
            const SizedBox(width: 8),
            Text(
              option,
              style: TextStyle(
                  color: isDisabled ? Colors.grey : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
            const Spacer(),
            if (isDisabled)
              Text(
                votes[index].toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final bool isEnabled = enableSubmit && selectedOption != null;

    return SizedBox(
      width: 200,
      height: 35,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [AppColors.dustyLavender, AppColors.mistyMorn],
                )
              : LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade300],
                ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            enableSubmit ? "Submit" : "Submitted",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
