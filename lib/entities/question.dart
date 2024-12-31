// this class demonstrate what a `Question` is
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
    // Creates a `Question` object from a JSON map.
    // The JSON map should contain the following keys: `question`, `answers`, `correct_answers`
    // If any of the expected keys are missing in the JSON map, default values are used (empty strings)
    // Returns a `Question` object with the parsed data from the JSON map.
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
