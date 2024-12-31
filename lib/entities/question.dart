// this class demonstrate what a 'News' is
class Question {
  final String question;
  final List<String> answers;
  final String correctAnswer;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  // this method is used to convert json data to 'Question' objects with detailed structure
  factory Question.fromDetailedJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] ?? '',
      answers: [
        json['answers']['answer_a'] ?? '',
        json['answers']['answer_b'] ?? '',
        json['answers']['answer_c'] ?? '',
        json['answers']['answer_d'] ?? '',
        json['answers']['answer_e'] ?? '',
        json['answers']['answer_f'] ?? '',
      ],
      correctAnswer: json['correct_answers'].entries
          .firstWhere(
            (entry) => entry.value == 'true',
            orElse: () => MapEntry('', ''),
          )
          .key
          .replaceAll('_correct', ''),
    );
  }
}
