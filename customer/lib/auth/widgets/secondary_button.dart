import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Secondary button widget with icon support (for Google sign-in)
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconPath,
    this.icon,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final String? iconPath;
  final Widget? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEFEFEF),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
              width: 1.0,
            ),
          ),
          elevation: 0,
        ),
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                width: 24,
                height: 24,
              )
            else if (icon != null)
              icon!,
            if ((iconPath != null || icon != null)) const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

