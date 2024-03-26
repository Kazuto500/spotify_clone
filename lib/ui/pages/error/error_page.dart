import 'package:flutter/material.dart';
import 'package:spotify_clone/ui/global/buttons/secondary_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "Error",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "This issue typically arises when there is an increase in concurrent requests, a common scenario where the Spotify API imposes limitations on the frequency of requests within specific time periods. Alternatively, among less predictable factors, it may occur due to obsolete credentials or an abnormal authorization token expiration",
                    textAlign: TextAlign.center,
                    maxLines: 10,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SecondaryButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("splash", (route) => false);
                    },
                    label: "Ok",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
