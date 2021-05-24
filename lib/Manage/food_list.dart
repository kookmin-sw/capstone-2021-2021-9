class FoodList {
  String name;
  String expirationDate;

  FoodList(
      {
        this.name, this.expirationDate
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

// class FoodList {
//   final List<Food> foods;
//
//   FoodList({
//     this.foods,
//   });
//
//   factory FoodList.fromJson(List<dynamic> parsedJson) {
//     List<Food> foods = new List<Food>();
//     foods = parsedJson.map((i) => Food.fromJson(i)).toList();
//
//     return new FoodList(
//         foods: foods
//     );
//   }
// }
//
// class Food {
//
//   String name;
//   String expirationDate;
//
//   Food (
//       {
//         this.name,
//         this.expirationDate
//       });
//
//   factory Food.fromJson(Map<String, dynamic> json){
//     return new Food(
//       name: json['name'],
//       expirationDate: json['expirationDate'],
//     );
//   }
}