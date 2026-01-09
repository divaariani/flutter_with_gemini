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
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Integration with Gemini'),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your prompt',
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      gemini
                          .prompt(parts: [Part.text(controller.text)])
                          .then((value) {
                            setState(() {
                              generatedResponse = value?.output;
                              isLoading = false;
                            });
                          })
                          .catchError((e) {
                            setState(() {
                              () => isLoading = false;
                              debugPrint('Error: $e');
                            });
                          });
                    },
                    child: const Text('Generate Response'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
