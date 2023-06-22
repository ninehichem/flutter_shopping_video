class Category {
  int? id;
  String? text;

  Category({
    this.id,
    this.text
  });

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["key"],
      text: json["text"] ?? "", 
    );
  }
}