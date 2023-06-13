class ContestDataModel {
  final String contestId;
  final String time;
  final String description;
  final String displayName;
  final String imageUrl;
  final String color;
  ContestDataModel(
       this.contestId,
       this.time,
       this.description,
       this.displayName,
       this.imageUrl,
       this.color,
      );

}


class ContestDataHolder {
  static List<Map<String, dynamic>> contestDataList = [];
}

class quizSectionDataHolder {
  static List<Map<String, dynamic>> quizSectionDataList = [];
}