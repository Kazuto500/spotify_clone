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
                    "Error while processing request",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "This can commonly occur because too many simultaneous requests were made (In some cases the Spotify API limits the number of requests for a certain period of time).\n\nAmong other less likely reasons, it happens because the credentials are no longer valid or your authorization token has expired abnormally.",
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
