class Story {
  final String story;
  final List<String> storyParts;
  final List<String> blankSpots;
  final List<String> wordsToChooseFrom;
  final List<String> correctAnswer;

  Story({
    required this.story,
    required this.storyParts,
    required this.blankSpots,
    required this.wordsToChooseFrom,
    required this.correctAnswer,
  });
}

// Danh sách stories được khai báo ở ngoài lớp
List<Story> stories = [
  Story(
    story: "A full story text here...",
    storyParts: ["First part of story", "second part", "final part"],
    blankSpots: ["missing word 1", "missing word 2"],
    wordsToChooseFrom: ["word1", "word2", "word3"], // Loại bỏ dấu "..."
    correctAnswer: [
      "correct word for first blank",
      "correct word for second blank"
    ],
  ),
  // More stories...
];

// Hàm randomize stories được khai báo ở ngoài
List<Story> getRandomizedStories(List<Story> originalStories) {
  // Triển khai logic randomize
  var shuffledStories = List<Story>.from(originalStories);
  shuffledStories.shuffle(); // Randomize thứ tự câu chuyện

  // Randomize các từ để chọn trong mỗi câu chuyện
  for (var story in shuffledStories) {
    story.wordsToChooseFrom.shuffle();
  }

  return shuffledStories;
}