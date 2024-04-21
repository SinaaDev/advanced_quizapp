import 'dart:io';
import 'package:advanced_quizapp/model/quiz.dart';
import 'package:advanced_quizapp/provider/quiz.dart';
import 'package:advanced_quizapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddQuizScreen extends StatefulWidget {
  AddQuizScreen({super.key});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final option1 = TextEditingController();
  final option2 = TextEditingController();
  final option3 = TextEditingController();
  final option4 = TextEditingController();
  final correctAnswer = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool loading = false;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image!.path);
    });
  }

   uploadItem() async {
    setState(() {
      loading = true;
    });
    if (selectedImage != null &&
        option1.text != "" &&
        option2.text != "" &&
        option3.text != "" &&
        option4.text != "" &&
        (correctAnswer.text == option1.text ||
            correctAnswer.text == option2.text ||
            correctAnswer.text == option3.text ||
            correctAnswer.text == option4.text)) {
      print('OPTION 1: ${option1.text}');
      print('OPTION 2: ${option2.text}');
      print('OPTION 3: ${option3.text}');
      print('OPTION 4: ${option4.text}');
      print('CORRECT ANSWER: ${correctAnswer.text}');
      print('CATEGORY: ${selectedValue}');

      final quiz = Quiz(image: '',
          option1: option1.text.trim(),
          option2: option2.text.trim(),
          option3: option3.text.trim(),
          option4: option4.text.trim(),
          correct: correctAnswer.text.trim(),
          category: selectedValue!);

      await Provider.of<Q>(context,listen: false).addQuiz(quiz,selectedImage!);
      setState(() {
        loading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>AddQuizScreen()));
    } else {
      print('FAILED');
      setState(() {
        loading= false;
      });
      return;
    }
  }

  final List<String> categories = [
    'Places',
    'Animals',
    'Fruits',
    'Tools',
    'Sports',
    'Random'
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Quiz',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>HomeScreen()));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Upload the Quiz Picture',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                selectedImage != null
                    ? Center(
                  child: GestureDetector(
                    onTap: getImage,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : Center(
                  child: GestureDetector(
                    onTap: getImage,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1.5),
                        ),
                        child: Icon(Icons.camera),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                optionItem(title: 'Option 1', controller: option1),
                SizedBox(height: 20),
                optionItem(title: 'Option 2', controller: option2),
                SizedBox(height: 20),
                optionItem(title: 'Option 3', controller: option3),
                SizedBox(height: 20),
                optionItem(title: 'Option 4', controller: option4),
                SizedBox(height: 20),
                optionItem(title: 'Correct Answer', controller: correctAnswer),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Category',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xffececf8),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: categories
                          .map(
                            (item) =>
                            DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                      )
                          .toList(),
                      onChanged: (value) =>
                          setState(() {
                            selectedValue = value;
                          }),
                      dropdownColor: Colors.white,
                      hint: Text('Select Category'),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      iconSize: 36,
                      value: selectedValue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: uploadItem,
                    child: loading? SizedBox(
                      height: 25,
                        width: 25,
                        child: CircularProgressIndicator()) : Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 53, 51, 51),
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Column optionItem(
    {required String title, required TextEditingController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      SizedBox(height: 6),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffececf8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter $title',
          ),
          textInputAction: TextInputAction.next,
          controller: controller,
        ),
      )
    ],
  );
}
