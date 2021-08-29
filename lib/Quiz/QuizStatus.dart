import 'package:flutter/material.dart';

class QuizStatus with ChangeNotifier{
  bool _isStarted = false;
  bool _isEnded = false;
  int _currentQuestion = 1;
  int _correct = 0;

  bool get isStarted => _isStarted;
  bool get isEnded => _isEnded;
  int get currentQuestion => _currentQuestion;
  int get correct => _correct;

  void end() {
    _isStarted = false;
    _isEnded = true;
    _correct = 0;
    _currentQuestion = 1;
    notifyListeners();
  }

  void start() {
    _isStarted = true;
    notifyListeners();
  }

  void correctAnswer() {
    _currentQuestion ++;
    _correct ++;
    notifyListeners();
  }


}