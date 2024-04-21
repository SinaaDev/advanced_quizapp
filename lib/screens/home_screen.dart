import 'package:advanced_quizapp/screens/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/quiz.dart';

class HomeScreen extends StatefulWidget {
  String? fullName;
  HomeScreen([this.fullName]);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Q>(context,listen: false).setFullName();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffedf3f6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 50),
                  height: 220,
                  decoration: BoxDecoration(
                      color: Color(0xFF2a2b31),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          'assets/profile.jpg',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.fullName??Provider.of<Q>(context).fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(onPressed: (){}, icon: Icon(Icons.manage_accounts,color: Colors.white,size: 32,))
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(left: 24, right: 24, top: 120),
                  child: Row(
                    children: [
                      Image.asset('assets/thinking.png'),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Play & Win',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Play Quiz by guessing the image',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                'Top Quiz Categories',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuizItem(
                    context: context,
                    image: 'assets/place.png',
                    title: 'Places'),
                QuizItem(
                    context: context,
                    image: 'assets/animal.png',
                    title: 'Animals'),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuizItem(
                    context: context,
                    image: 'assets/fruit.png',
                    title: 'Fruits'),
                QuizItem(
                    context: context, image: 'assets/tool.png', title: 'Tools'),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuizItem(
                    context: context,
                    image: 'assets/sport.png',
                    title: 'Sports'),
                QuizItem(
                    context: context,
                    image: 'assets/random.png',
                    title: 'Random'),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector QuizItem(
      {required BuildContext context,
      required String image,
      required String title}) {
    return GestureDetector(
      onTap: () {
        Provider.of<Q>(context,listen: false).fetchAndSetQuiz(title);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => QuestionScreen(),
            settings: RouteSettings(arguments: title),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        child: Container(
          width: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Image.asset(
                image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              )
            ],
          ),
        ),
      ),
    );
  }
}
