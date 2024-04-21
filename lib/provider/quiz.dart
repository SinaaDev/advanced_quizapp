import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Q with ChangeNotifier {
  List<Quiz> _quiz = [];
  String fullName = 'User';

  List<Quiz> get quiz {
    return [..._quiz];
  }

  Future<void> setFullName()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString('fullName')??fullName;
    print('THIS IS THE FULL NAME FROM PROVIDER: $fullName');
  }

  Future<void> addQuiz(Quiz quiz,File image) async {
    // server url
    final url = Uri.parse(
        'https://quiz-6fb93-default-rtdb.firebaseio.com/${quiz.category}.json');

    //uploading the image to server and get the url
    var dio = Dio();

    FormData data = FormData.fromMap({
      'key':'1d6ee2344dd6a2a745e5e5b9798294d3',
      'image': await MultipartFile.fromFile(image.path,filename: image.path.split('/').last),
    });
    print('UPLOADING STARTED!!----------------------------------');
    var imageResponse = await dio.post('https://api.imgbb.com/1/upload',data: data);
    print(imageResponse.data);
    String imageUrl = imageResponse.data['data']['display_url'];

    //sending the quiz options to server
    final response = await http.post(url,
        body: json.encode({
          'imageUrl': imageUrl,
          'option1': quiz.option1,
          'option2': quiz.option2,
          'option3': quiz.option3,
          'option4': quiz.option4,
          'correct': quiz.correct,
          'category': quiz.category
        }));

    // inserting the new quiz into list of quizzes
    final _newQuiz = Quiz(
        image: imageUrl,
        option1: quiz.option1,
        option2: quiz.option2,
        option3: quiz.option3,
        option4: quiz.option4,
        correct: quiz.correct,
        category: quiz.category);
    _quiz.insert(0, _newQuiz);
    notifyListeners();
  }

  Future<void> fetchAndSetQuiz(String category) async {
    print('FETCH AND SET QUIZZES-------------------');
    final url = Uri.parse('https://quiz-6fb93-default-rtdb.firebaseio.com/$category.json');
    final response = await http.get(url);
    print('RESPONSE OF GET: ${response.body}');
    final List<Quiz> loadedQuiz = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    if (extractedData.isEmpty) {
      throw Exception('No data found');
    }
    extractedData.forEach((quizId, quizData) {
      print('fetch---------------------------------------------------------');
      print(quizData['imageUrl']);
      print(quizData['option1']);
      print(quizData['option2']);
      print(quizData['option3']);
      print(quizData['option4']);
      loadedQuiz.insert(
        0,
        Quiz(
          image: quizData['imageUrl'],
          option1: quizData['option1'],
          option2: quizData['option2'],
          option3: quizData['option3'],
          option4: quizData['option4'],
          correct: quizData['correct'],
          category: quizData['category'],
        ),
      );
    });
    _quiz = loadedQuiz;
    notifyListeners();

  }

  Future<String> uploadImage(File image)async{
    //Thanks to IMGBB.com for providing image uploading feature!
    var dio = Dio();

    FormData data = FormData.fromMap({
      'key':'1d6ee2344dd6a2a745e5e5b9798294d3',
      'image': await MultipartFile.fromFile(image.path,filename: image.path.split('/').last),
    });
    print('UPLOADING STARTED!!----------------------------------');
    var response = await dio.post('https://api.imgbb.com/1/upload',data: data);
    print('DONE');
    print(response.data);
    return response.data['data']['display_url'];
  }

  bool show = false;

  void showAnswers() {
    show = true;
    notifyListeners();
  }
}
