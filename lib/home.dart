import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _inputController = TextEditingController();
  final List<String> chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ...chats.map(
                (chat) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(chat),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    helperText: 'Enter your prompt'),
              ),
            ),
            IconButton(
              onPressed: () {
                debugPrint(_inputController.text);
              },
              icon: const Icon(Icons.send),
            )
          ],
        )
      ]),
    );
  }
}
