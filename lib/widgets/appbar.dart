import 'package:flutter/material.dart';
import 'package:lifance/misc/global.dart';
import 'package:lifance/widgets/emoji_text.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Global.instance.streak == -1
            ? FutureBuilder(
                future: Global.instance.fetchStreak(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container();
                  } else {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Streak"),
                                      content: Text(
                                          "This is your streak.\n\nA streak is a continuous series of challenges completed on consecutive days.\n\nBy completing challenges day after day, you can increase your streak."),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Got it")),
                                      ],
                                    )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const EmojiText(text: '🔥'),
                                    Text(
                                      " ${Global.instance.streak}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ]),
                            ),
                          ),
                          const Text(' '),
                          GestureDetector(
                              onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Radius"),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                                "This is the radius the challenge goal can be generated in."),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Image.asset("assets/img/radius.png",
                                                alignment: Alignment.center),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                                "The first value is the minimum distance between you and the challenge goal and the last value is the maximum distance between you and the challenge goal."),

                                            //"),
                                          ]),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Got it")),
                                      ],
                                    ),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.blur_circular,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    Text(
                                      Global.instance.radiusText,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ))
                        ]);
                  }
                },
              )
            : Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Streak"),
                            content: Text(
                                "This is your streak.\n\nA streak is a continuous series of challenges completed on consecutive days.\n\nBy completing challenges day after day, you can increase your streak."),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Got it")),
                            ],
                          )),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const EmojiText(text: '🔥'),
                        Text(
                          " ${Global.instance.streak}",
                          style: const TextStyle(fontSize: 14),
                        )
                      ]),
                ),
                const Text(' '),
                GestureDetector(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Radius"),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        "This is the radius the challenge goal can be generated in."),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Image.asset(
                                      "assets/img/radius.png",
                                      alignment: Alignment.center,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                        "The first value is the minimum distance between you and the challenge goal and the last value is the maximum distance between you and the challenge goal.")
                                    //"),
                                  ]),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Got it")),
                              ],
                            )),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.blur_circular,
                          color: Colors.deepOrangeAccent,
                        ),
                        Text(
                          Global.instance.radiusText,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ))
              ]));
  }
}
