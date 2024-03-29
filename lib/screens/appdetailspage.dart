import 'package:firebase_login_project/utils/project_variables.dart';
import 'package:flutter/material.dart';

class AppDetailsPage extends StatefulWidget {
  const AppDetailsPage({Key? key}) : super(key: key);

  @override
  State<AppDetailsPage> createState() => _AppDetailsPageState();
}

class _AppDetailsPageState extends State<AppDetailsPage> {
  Color secondColor = ColorItems.mainColor;
  List<String> yonergeList = [];

  @override
  void initState() {
    yonergeList.add("1. User can add new words from homepage and translation page.");
    yonergeList
        .add("2. Words can be transferred between the word list and archive pages by clicking the transfer buttons.");
    yonergeList.add(
        "3. User can hide and show word meanings using buttons. In addition, the user can choose which side to hide.");
    yonergeList.add("4. User can delete words by double clicking on them.");
    yonergeList.add("5. At least 4 words must be added to the list for the speed test.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightSize = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usage Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: heightSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.green.shade400,
            Colors.blue.shade900,
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SizedBox(
            width: screenWidth,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 24,
              ),
              shrinkWrap: true,
              itemCount: yonergeList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Text(
                  yonergeList[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
