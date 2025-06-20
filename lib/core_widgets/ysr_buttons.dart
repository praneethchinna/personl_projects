import 'package:flutter/material.dart';

// Defines a custom button widget with gradient background and hover effects.
class YsrButton extends StatefulWidget {
  // The text displayed on the button.
  final String text;
  // The callback function executed when the button is pressed.
  final VoidCallback onPressed;
  // A list of colors to create the linear gradient background.
  final List<Color> gradientColors;
  // The color of the button's text. Defaults to white.
  final Color? textColor;
  // The width of the button. Defaults to full width (double.infinity).
  final double? width;
  // The height of the button. Defaults to 50.
  final double? height;
  // The font size of the button's text. Defaults to 16.
  final double? fontSize;

  const YsrButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradientColors,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  State<YsrButton> createState() => _YsrButtonState();
}

class _YsrButtonState extends State<YsrButton> {
  // State variable to track if the mouse cursor is hovering over the button.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Changes the cursor to a pointing hand when hovering over the button.
      cursor: SystemMouseCursors.click,
      // Callback when the mouse pointer enters the region.
      onEnter: (_) {
        setState(() {
          _isHovered = true; // Set hover state to true
        });
        // Unfocuses any currently focused input field when hovering over the button.
        FocusScope.of(context).unfocus();
      },
      // Callback when the mouse pointer exits the region.
      onExit: (_) {
        setState(() {
          _isHovered = false; // Set hover state to false
        });
      },
      child: AnimatedContainer(
        // Duration for the animation when properties change (e.g., color on hover).
        duration: const Duration(milliseconds: 200),
        // Width of the button, using the provided width or defaulting to full width.
        width: widget.width ?? double.infinity,
        // Height of the button, using the provided height or defaulting to 50.
        height: widget.height ?? 50,
        decoration: BoxDecoration(
          // Conditional color for the button based on hover state.
          // If hovered, the background becomes black.
          // If not hovered, it's null, allowing the gradient to take effect.
          color: _isHovered ? Colors.black : null,
          // Conditional gradient for the button based on hover state.
          // If hovered, the gradient is null (so the solid black color applies).
          // If not hovered, the linear gradient uses the provided colors.
          gradient: _isHovered ? null : LinearGradient(colors: widget.gradientColors),
          // Applies rounded corners to the button.
          borderRadius: BorderRadius.circular(30),
          // Border is removed as per the original comment's implied intent ("No border").
          // If a border is desired, it should be added here explicitly with color and width.
        ),
        child: TextButton(
          // The onPressed callback provided by the user.
          onPressed: widget.onPressed,
          // Defines the style of the TextButton, making it transparent and removing default padding.
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent, // Ensures no default background interference.
            padding: EdgeInsets.zero, // Removes default padding of TextButton.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Ensures tap area matches container's rounded corners.
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              // Text color, defaulting to white.
              color: widget.textColor ?? Colors.white,
              // Font size, defaulting to 16.
              fontSize: widget.fontSize ?? 16,
            ),
          ),
        ),
      ),
    );
  }
}
