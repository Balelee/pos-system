import 'package:flutter/material.dart';

enum ToastType { success, error, warning }

class CustomToast {
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    Color backgroundColor;
    IconData icon;
    Color iconColor;
    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green.shade600;
        icon = Icons.check_circle;
        iconColor = Colors.white;
        break;
      case ToastType.error:
        backgroundColor = Colors.red.shade700;
        icon = Icons.error;
        iconColor = Colors.white;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange.shade700;
        icon = Icons.warning;
        iconColor = Colors.white;
        break;
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 20,
        right: 20,
        child: _ToastWidget(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          iconColor: iconColor,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration).then((_) => overlayEntry.remove());
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
