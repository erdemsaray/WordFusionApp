import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/project_variables.dart';
import '../widget/navigation_drawer_widget.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

String? websiteURL;
Color specialRedColor = const Color.fromARGB(255, 126, 23, 18);
String homePageUrl = "https://translate.google.com/?hl=tr";

class _TranslatePageState extends State<TranslatePage> {
  bool isLoading = true;
  late WebViewController controller; //!!!! hataya yol açmazsa kaldırılacak.
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.08;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.reload();
        },
        child: const Icon(Icons.rss_feed),
      ),
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: ColorItems.mainColor,
        title: const Text('Translate Page'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: size),
            child: WebView(
              backgroundColor: Colors.white,
              initialUrl: homePageUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onPageStarted: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              onPageFinished: (url) {},
            ),
          ),
          isLoading
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 100, left: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/newword.png"),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: LinearProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(),
        ],
      ),
    );
  }
}
