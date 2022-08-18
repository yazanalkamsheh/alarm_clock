class FlutterClockUserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  bool? isEmailVerfied;

  FlutterClockUserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.isEmailVerfied,
  });

  FlutterClockUserModel.fromJson(Map<String,dynamic> json)
  {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    isEmailVerfied = json['isEmailVerfied'];

  }

  Map<String,dynamic> toMap()
  {
    return{
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'image':image,
      'cover':cover,
      'isEmailVerfied':isEmailVerfied,
    };
  }
}