import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MicrosoftLoginScreen extends StatelessWidget {
  const MicrosoftLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(dotenv.env["AUTH_URL"] ?? "AUTH_URL not set");
    final webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          final redirectUri = Uri.parse(request.url).queryParameters["redirect_uri"];
          if (redirectUri == null) {
            Navigator.of(context).pop();
            return NavigationDecision.prevent;
          }
          if (request.url.startsWith(redirectUri)) {
            final code = Uri.parse(request.url).queryParameters["code"];
            Navigator.of(context).pop(code);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(uri);
    return Scaffold(
      body: WebViewWidget(
        controller: webController,
      ),
    );
  }
}
