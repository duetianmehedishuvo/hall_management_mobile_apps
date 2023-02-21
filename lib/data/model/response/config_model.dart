class ConfigModel {
  ConfigModel({
    this.id,
    this.mealRate,
    this.offlineTakaLoadTime,
    this.guestMealRate,
    this.isAvaibleGuestMeal,
  });

  ConfigModel.fromJson(dynamic json) {
    id = json['id'];
    mealRate = json['meal_rate']??"";
    offlineTakaLoadTime = json['offline_taka_load_time'];
    guestMealRate = json['guest_meal_rate'];
    isAvaibleGuestMeal = json['isAvaibleGuestMeal'];
  }

  num? id;
  String? mealRate;
  String? offlineTakaLoadTime;
  String? guestMealRate;
  num? isAvaibleGuestMeal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['meal_rate'] = mealRate;
    map['offline_taka_load_time'] = offlineTakaLoadTime;
    map['guest_meal_rate'] = guestMealRate;
    map['isAvaibleGuestMeal'] = isAvaibleGuestMeal;
    return map;
  }
}
