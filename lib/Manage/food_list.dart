class FoodList {
  String name;
  String expirationDate;

  FoodList(
      {
        this.name,
        this.expirationDate
      });

  FoodList.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    expirationDate = json['ExpirationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ExpirationDate'] = this.expirationDate;
    return data;
  }
}