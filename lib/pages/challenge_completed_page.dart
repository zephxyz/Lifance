import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifance/misc/firestore.dart';
import 'package:lifance/misc/global.dart';

class ChallengeCompletedPage extends StatelessWidget {
  const ChallengeCompletedPage({super.key});

  Future<void> skipTakingPhoto(BuildContext context) async {
    await Firestore.instance
        .addChallengeToHistory(
            Global.instance.challenge.lat,
            Global.instance.challenge.lng,
            Global.instance.challenge.totalDistance,
            null, null)
        .then((_) {
      Global.instance.resetChallengeValues();
      context.go('/');
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Challenge completed!",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          Column(children: [
            Text(
                "Distance traveled: ${Global.instance.challenge.totalDistance}m",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Text("Time taken: ${Global.instance.challenge.timeTakenFormatted}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ]),
          const Text(
            "Now take a photo to comemorate your achievement!",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                  onPressed: () => skipTakingPhoto(context),
                  child: const Text("Skip")),
              ElevatedButton(
                  onPressed: () => context.go('/photopage'),
                  child: const Text("Take photo"))
            ],
          ),
        ],
      ),
    );
  }
}
