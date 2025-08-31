import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  const GoogleButton({super.key, this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    const double kHeight = 48;
    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: kHeight,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 16,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Image.asset(
                        'assets/images/google_logo.png',
                        width: 20,
                        height: 20,
                      ),
              ),
              const Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
