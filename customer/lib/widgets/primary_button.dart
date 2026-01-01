import 'package:flutter/material.dart';

/// Professional primary button widget with customizable colors
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF7B51B7),
    this.foregroundColor = Colors.white,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Check if button should have border (outlined style)
    final isOutlined = backgroundColor == Colors.white || 
                       backgroundColor.value == Colors.grey.shade100.value ||
                       backgroundColor.value == 0xFFF5F5F5; // Light gray
    
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled 
              ? backgroundColor 
              : backgroundColor.withOpacity(0.4),
          foregroundColor: enabled 
              ? foregroundColor 
              : foregroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: isOutlined
                ? BorderSide(
                    color: enabled 
                        ? Colors.grey.shade300 
                        : Colors.grey.shade200,
                    width: 1.4,
                  )
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: enabled ? foregroundColor : foregroundColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
