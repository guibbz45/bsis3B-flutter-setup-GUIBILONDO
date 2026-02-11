import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuizPage(),
    );
  }
}

enum QuizStage { start, quiz, end }

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizStage stage = QuizStage.start;
  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  int? selectedIndex;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is the most commonly used type of transmission in modern cars?",
      "options": ["Manual", "Automatic", "CVT", "Dual-clutch"],
      "answerIndex": 1,
    },
    {
      "question": "Which of these is the fastest 0-60 car?",
      "options": ["Ferrari F8 Tributo", "Lamborghini Aventador", "Bugatti Chiron", "Tesla Model S Plaid"],
      "answerIndex": 3,
    },
    {
      "question": "What does ABS stand for in cars?",
      "options": ["Advanced Braking System", "Anti-lock Braking System", "Automatic Brake Speed", "Auxiliary Brake Sensor"],
      "answerIndex": 1,
    },
    {
      "question": "Which car manufacturer is known for the iconic Beetle?",
      "options": ["BMW", "Mercedes-Benz", "Volkswagen", "Audi"],
      "answerIndex": 2,
    }

  

  ];

  void startQuiz() {
    setState(() {
      stage = QuizStage.quiz;
      currentQuestion = 0;
      score = 0;
      answered = false;
      selectedIndex = null;
    });
  }

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedIndex = index;
      if (index == questions[currentQuestion]["answerIndex"]) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
        answered = false;
        selectedIndex = null;
      } else {
        stage = QuizStage.end;
      }
    });
  }

  void restartQuiz() {
    setState(() {
      stage = QuizStage.start;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Knowledge Quiz"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(221, 51, 120, 141),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              const Color.fromARGB(255, 168, 148, 148),
              const Color.fromARGB(255, 52, 85, 146),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Icon(
                Icons.directions_car,
                size: 120,
                color: const Color.fromARGB(255, 203, 223, 217).withOpacity(0.2),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              child: Icon(
                Icons.engineering,
                size: 100,
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 30,
              child: Icon(
                Icons.speed,
                size: 90,
                color: const Color.fromARGB(255, 30, 40, 41).withOpacity(0.15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (stage) {
      case QuizStage.start:
        return _buildStartView();
      case QuizStage.quiz:
        return _buildQuizView();
      case QuizStage.end:
        return _buildEndView();
    }
  }

  Widget _buildStartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car, size: 80, color: Color.fromARGB(255, 170, 197, 219)),
          const SizedBox(height: 20),
          const Text(
            "Car Quiz Master",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text("Test your knowledge about cars and vehicles"),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            onPressed: startQuiz,
            child: const Text("Start Quiz"),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    final question = questions[currentQuestion];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: (currentQuestion + 1) / questions.length),
        const SizedBox(height: 20),
        Text(
          "Question ${currentQuestion + 1}/${questions.length}",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Text(
          question["question"],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),
        ...List.generate(question["options"].length, (index) {
          Color buttonColor = Colors.blue;
          if (answered) {
            if (index == question["answerIndex"]) {
              buttonColor = Colors.green;
            } else if (index == selectedIndex) {
              buttonColor = Colors.red;
            } else {
              buttonColor = Colors.grey.shade300;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: answered && index != question["answerIndex"] && index != selectedIndex ? Colors.black54 : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: answered ? null : () => selectAnswer(index),
              child: Text(question["options"][index], style: const TextStyle(fontSize: 16)),
            ),
          );
        }),
        const Spacer(),
        if (answered)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: nextQuestion,
            child: Text(currentQuestion == questions.length - 1 ? "Finish" : "Next Question"),
          ),
      ],
    );
  }

  Widget _buildEndView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Quiz Completed!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(
            "Final Score: $score / ${questions.length}",
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: restartQuiz,
            label: const Text("Restart Quiz"),
          ),
        ],
      ),
    );
  }
}