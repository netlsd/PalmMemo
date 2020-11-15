class Word {
  String word;
  String mean;

  Word(this.word, this.mean);

  // null for AUTOINCREMENT
  Map<String, dynamic> toMap() {
    return {
      'id': null,
      'word': word,
      'mean': mean,
    };
  }
}
