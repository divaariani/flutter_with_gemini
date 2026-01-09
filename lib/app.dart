import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;
  String? generatedResponse;
  bool isLoading = false;
  final TextEditingController controller = TextEditingController();

  void _sendPrompt() {
    final text = controller.text.trim();
    if (text.isEmpty || isLoading) return;

    setState(() {
      isLoading = true;
      generatedResponse = null;
    });

    gemini
        .prompt(parts: [Part.text(text)])
        .then((value) {
          setState(() {
            generatedResponse = value?.output;
            isLoading = false;
          });
        })
        .catchError((e) {
          setState(() {
            isLoading = false;
          });
          debugPrint('Error: $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ask anything',
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendPrompt(),
                  ),
                ),
                const SizedBox(width: 8),
                isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: _sendPrompt,
                        icon: const Icon(Icons.send),
                      ),
              ],
            ),
            const SizedBox(height: 20),
            if (generatedResponse != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    generatedResponse ?? '-',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
