import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/quiz.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String category =
        ModalRoute.of(context)?.settings.arguments as String;
    final quiz = Provider.of<Q>(context)
        .quiz
        .where((quiz) => quiz.category == category)
        .toList();
    final pageController = PageController();
    return Scaffold(
      backgroundColor: Color(0xff004840),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
            Provider.of<Q>(context, listen: false).show = false;
          },
          color: Colors.white,
          padding: EdgeInsets.only(right: 16),
        ),
        backgroundColor: Color(0xff004840),
        centerTitle: true,
        title: Text(
          category,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        itemBuilder: (ctx, i) => QuizPage(
          image: quiz[i].image,
          option1: quiz[i].option1,
          option2: quiz[i].option2,
          option3: quiz[i].option3,
          option4: quiz[i].option4,
          correct: quiz[i].correct,
        ),
        itemCount: quiz.length,
      ),
      floatingActionButton: Provider.of<Q>(context).show
          ? FloatingActionButton(
              onPressed: () {
                Provider.of<Q>(context, listen: false).show
                    ? pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut)
                    : null;
                Provider.of<Q>(context, listen: false).show = false;
              },
              backgroundColor: Color(0xff004840),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
              child: Icon(
                Icons.navigate_next_rounded,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}

class QuizPage extends StatelessWidget {
  final String image;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String correct;

  const QuizPage({
    super.key,
    required this.image,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    print('WIDGET BUILT');
    final quiz = Provider.of<Q>(context);
    bool show = quiz.show;
    GestureDetector ans(String option) => GestureDetector(
          onTap: () {
            quiz.showAnswers();
          },
          child: show
              ? Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 1.5,
                          color: correct == option ? Colors.green : Colors.red),
                      color: correct == option ? Colors.green : Colors.white),
                  child: Text(
                    option,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: correct == option ? Colors.white : Colors.black),
                  ),
                )
              : Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1.5, color: Color(0xff818181)),
                      color: Colors.white),
                  child: Text(
                    option,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
        );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      LinearProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ans(option1),
            ans(option2),
            ans(option3),
            ans(option4),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     SizedBox(
            //       height: 50,
            //       width: 50,
            //       child: ElevatedButton(
            //         onPressed: () {
            //           QuestionScreen().
            //         },
            //         child:
            //             Icon(Icons.navigate_next_rounded, color: Colors.white),
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: Color(0xff004840),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(35))),
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
