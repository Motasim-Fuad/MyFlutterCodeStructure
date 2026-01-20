import 'package:flutter/material.dart';


// ICON POSITION - Left or Right
enum IconPosition { left, right }


class CustomButton extends StatelessWidget {
  // ====== PROPERTIES ======
  final bool loading; // Loading state
  final String title; // Button text
  final String loadingText; // Loading text
  final bool showLoader; // Spinner show korbe kina
  final bool showLoadingText; // Loading text show korbe kina
  final double height, width; // Size
  final VoidCallback onPress; // Click callback
  final Color textColor, buttonColor; // Colors
  final List<Color>? gradientColors; // Gradient (optional)
  final IconData? icon; // Icon (optional)
  final double iconSpacing; // Icon spacing
  final IconPosition iconPosition; // Icon position

  CustomButton({
    Key? key,
    this.gradientColors,
    this.buttonColor = Colors.blue,
    this.textColor = Colors.white,
    required this.title,
    required this.onPress,
    this.width = 60,
    this.height = 50,
    this.loading = false,
    this.loadingText = 'Please wait...',
    this.showLoader = false,
    this.showLoadingText = false,
    this.icon,
    this.iconSpacing = 8.0,
    this.iconPosition = IconPosition.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Loading e tap disable
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: gradientColors != null
              ? LinearGradient(
            colors: gradientColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: gradientColors == null ? buttonColor : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: loading
          // LOADING STATE
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Spinner
              if (showLoader)
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              if (showLoader && showLoadingText)
                const SizedBox(width: 10),
              // Loading text
              if (showLoadingText)
                Text(
                  loadingText,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: textColor),
                ),
            ],
          )
          //NORMAL STATE
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon left
              if (icon != null && iconPosition == IconPosition.left)
                Icon(icon, color: textColor, size: 20),
              if (icon != null && iconPosition == IconPosition.left)
                SizedBox(width: iconSpacing),
              // Text
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: textColor),
              ),
              // Icon right
              if (icon != null && iconPosition == IconPosition.right)
                SizedBox(width: iconSpacing),
              if (icon != null && iconPosition == IconPosition.right)
                Icon(icon, color: textColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}