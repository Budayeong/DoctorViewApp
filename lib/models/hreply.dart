class Hreply {
  int replyIdx;
  DateTime date;
  String content;
  String rewrite;
  String writerRef;
  int reviewRef;

  Hreply({
    required this.replyIdx,
    required this.date,
    required this.content,
    required this.rewrite,
    required this.writerRef,
    required this.reviewRef,
  });

  factory Hreply.fromJson(Map<String, dynamic> json) {
    int parseInt(String? value) {
      return value != null ? int.parse(value) : 0;
    }

    return Hreply(
      replyIdx: parseInt(json['replyIdx']?.toString()),
      date: DateTime.parse(json['postdate']),
      content: json['content'] ?? '',
      rewrite: json['rewrite'] ?? '',
      writerRef: json['writerRef'] ?? '',
      reviewRef: parseInt(json['reviewRef']?.toString()),
    );
  }
  Map<String, dynamic> toJson() => {
    'replyIdx': replyIdx,
    'postdate': date.toIso8601String(),
    'content': content,
    'rewrite': rewrite,
    'writerRef': writerRef,
    'reviewRef': reviewRef,
  };
}