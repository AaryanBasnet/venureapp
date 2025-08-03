import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/auth/domain/use_case/verify_password_usecase.dart';

class SecureActionHandler {
  static Future<bool> verify(
    BuildContext context, {
    required String reason,
  }) async {
    final localAuth = LocalAuthentication();

    // Step 1: Show selection dialog
    final choice = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Authentication Required'),
            content: const Text('Choose authentication method'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'password'),
                child: const Text('Password'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'fingerprint'),
                child: const Text('Fingerprint'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );

    if (choice == 'cancel' || choice == null) return false;

    if (choice == 'password') {
      // Show password dialog directly
      return await _passwordFallback(context);
    }

    // choice == 'fingerprint'
    try {
      final isBiometricAvailable = await localAuth.canCheckBiometrics;
      final isDeviceSupported = await localAuth.isDeviceSupported();

      if (!isBiometricAvailable || !isDeviceSupported) {
        return await _passwordFallback(context);
      }

      final didAuthenticate = await localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable' ||
          e.code == 'NotEnrolled' ||
          e.code == 'LockedOut') {
        return await _passwordFallback(context);
      }
      if (e.code == 'UserCanceled' || e.code == 'UserFallback') {
        return false;
      }
      return await _passwordFallback(context);
    }
  }

  static Future<bool> _passwordFallback(BuildContext context) async {
    final controller = TextEditingController();

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Enter Password'),
                content: TextField(
                  controller: controller,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (await _validatePassword(controller.text)) {
                        Navigator.of(ctx).pop(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Incorrect password')),
                        );
                      }
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  static Future<bool> _validatePassword(String input) async {
    final localStorage = await LocalStorageService.getInstance();
    final userId = localStorage.userId;

    if (userId == null || userId.isEmpty) return false;

    final verifyPasswordUsecase = serviceLocator<VerifyPasswordUsecase>();

    final result = await verifyPasswordUsecase.call(
      VerifyPasswordParams(userId: userId, password: input),
    );

    return result.fold((failure) {
      print('[DEBUG] Password verification failed: ${failure.message}');
      return false;
    }, (isValid) => isValid);
  }
}
