import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TestResultPage extends StatefulWidget {
  final List<String> kelimeler;
  final int point;

  const TestResultPage({Key? key, required this.kelimeler, required this.point}) : super(key: key);

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: AnimatedTextKit(
          animatedTexts: [WavyAnimatedText("Speed Test Result")],
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade400, Colors.blue.shade900])),
        child: SafeArea(
          child: SizedBox(
            width: screenWidth - 100,
            height: screenHeight - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: widget.point == 0 ? false : true,
                  child: SizedBox(
                    height: 170,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Lottie.asset('assets/lottie/congratulations.json'),
                    ),
                  ),
                ),
                Text(
                  "Your Point: ${widget.point}",
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
                Text(
                  widget.kelimeler.isNotEmpty ? "You must repeat these words" : "All words answered correctly.",
                  style: const TextStyle(fontSize: 24, color: Colors.white60),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SizedBox(
                    width: screenWidth,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.kelimeler.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Text(
                          widget.kelimeler[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 24),
                        );
                      },
                    ),
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
