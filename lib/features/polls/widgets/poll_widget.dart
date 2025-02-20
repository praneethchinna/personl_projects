import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...optionWidgets,
            const SizedBox(height: 12),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/image_2.png"), // Change as needed
          radius: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          DateFormat("MMMM d, y").format(createdAt),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildOption(String option, int index) {
    return GestureDetector(
      onTap: () => onOptionSelected(option),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              selectedOption == option ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              selectedOption == option
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selectedOption == option ? Colors.green : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(option),
            Spacer(),
            if (!enableSubmit) Text(votes[index].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enableSubmit
            ? selectedOption != null
                ? onSubmit
                : null
            : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Color(0xFF0066B3),
        ),
        child: Text(
          enableSubmit ? "Submit" : "Submitted",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
