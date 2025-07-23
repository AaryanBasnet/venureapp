import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void navigateToPage({
  required BuildContext context,
  required Widget child,
  List<BlocProvider>? additionalProviders,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (newContext) {
        // newContext here is the context for the pushed route
        if (additionalProviders != null) {
          return MultiBlocProvider(
            providers: additionalProviders,
            child: child,
          );
        } else {
          return child;
        }
      },
    ),
  );
}
