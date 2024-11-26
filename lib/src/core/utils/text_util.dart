class TextUtil {
  static String toSentenceCase(String text) {
    if (text.isEmpty) return text;

    // Trim leading and trailing whitespaces
    text = text.trim();

    // Convert first character to uppercase and rest to lowercase
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String toSentenceCaseMultiple(String text) {
    if (text.isEmpty) return text;

    // Split the text into sentences using a period and trim spaces
    final sentences = text.split('.').map((sentence) => sentence.trim());

    // Apply sentence case to each sentence and join them with a period
    return sentences
        .map((sentence) => sentence.isEmpty
            ? ''
            : sentence[0].toUpperCase() + sentence.substring(1).toLowerCase())
        .join('. ');
  }
}
