import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool disabled;
  final bool busy;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.disabled = false,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: disabled ? Colors.black12 : Theme.of(context).primaryColor,
        ),
        child: busy
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: disabled ? Colors.black54 : Colors.white,
                ),
              ),
      ),
    );
  }
}
