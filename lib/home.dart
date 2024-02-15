import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'config.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _inputController = TextEditingController();
  late final ChatSession _session;
  final GenerativeModel _model =
      GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _session = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ..._session.history.map(
                (content) {
                  var text = content.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join('');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        content.role == 'user' ? 'User:' : 'Gemini:',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      MarkdownBody(data: text),
                      const SizedBox(height: 10.0),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your prompt',
                  ),
                ),
              ),
              _loading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send),
                    ),
            ],
          ),
        )
      ]),
    );
  }

  _sendMessage() async {
    setState(() {
      _loading = true;
    });
    try {
      final response =
          await _session.sendMessage(Content.text(_inputController.text));
      var text = response.text;

      if (text == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No response from API')));
        }
        return;
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _inputController.clear();
      setState(() {
        _loading = false;
      });
    }
  }

  _showError(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
