import 'dart:convert';
// To parse this JSON data, do
//
//     final userInformation = userInformationFromJson(jsonString);

UserInformation userInformationFromJson(String str) =>
    UserInformation.fromJson(json.decode(str));

String userInformationToJson(UserInformation data) =>
    json.encode(data.toJson());

class UserInformation {
  String? firstName;
  String? lastName;
  String? membershipNo;
  String? countryCode;
  String? mobileNumber;
  String? email;
  int? tierId;
  DateTime? tierExpiry;
  String? accountStatus;
  String? smsConsent;
  String? whatsappConsent;
  String? emailConsent;
  String? emailVerified;
  String? phoneVerified;
  dynamic addrLine1;
  dynamic addrLine2;
  String? dob;
  String? gender;
  int? cityId;
  List<Interest>? nationality;
  dynamic pinCode;
  String? image;
  String? isUaeResident;
  String? employmentType;
  String? referralCode;
  String? cityName;
  String? countryFlag;
  String? tier;
  List<Interest>? interests;
  List<Interest>? residentialCountry;
  int? rating;
  String? feedback;
  dynamic empCode;
  dynamic partnerName;
  int? pointBalance;
  int? tentativePoints;
  String? referralUrl;
  String? expiryMessage;

  UserInformation({
    this.firstName,
    this.lastName,
    this.membershipNo,
    this.countryCode,
    this.mobileNumber,
    this.email,
    this.tierId,
    this.tierExpiry,
    this.accountStatus,
    this.smsConsent,
    this.whatsappConsent,
    this.emailConsent,
    this.emailVerified,
    this.phoneVerified,
    this.addrLine1,
    this.addrLine2,
    this.dob,
    this.gender,
    this.cityId,
    this.nationality,
    this.pinCode,
    this.image,
    this.isUaeResident,
    this.employmentType,
    this.referralCode,
    this.cityName,
    this.countryFlag,
    this.tier,
    this.interests,
    this.residentialCountry,
    this.rating,
    this.feedback,
    this.empCode,
    this.partnerName,
    this.pointBalance,
    this.tentativePoints,
    this.referralUrl,
    this.expiryMessage,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      UserInformation(
          firstName: json["first_name"],
          lastName: json["last_name"],
          membershipNo: json["membership_no"],
          countryCode: json["country_code"],
          mobileNumber: json["mobile_number"],
          email: json["email"],
          tierId: json["tier_id"],
          tierExpiry: json["tier_expiry"] == null
              ? null
              : DateTime.parse(json["tier_expiry"]),
          accountStatus: json["account_status"],
          smsConsent: json["sms_consent"],
          whatsappConsent: json["whatsapp_consent"],
          emailConsent: json["email_consent"],
          emailVerified: json["email_verified"],
          phoneVerified: json["phone_verified"],
          addrLine1: json["addr_line_1"],
          addrLine2: json["addr_line_2"],
          dob: json["dob"],
          gender: json["gender"],
          cityId: json["city_id"],
          nationality: json["nationality"] == null || json["nationality"] == 0
              ? null
              : List<Interest>.from(
                  json["nationality"]!.map((x) => Interest.fromJson(x))),
          pinCode: json["pin_code"],
          image: json["image"],
          isUaeResident: json["is_uae_resident"],
          employmentType: json["employment_type"],
          referralCode: json["referral_code"],
          cityName: json["city_name"],
          countryFlag: json["country_flag"],
          tier: json["tier"],
          interests: json["interests"] == null
              ? []
              : List<Interest>.from(
                  json["interests"]!.map((x) => Interest.fromJson(x))),
          residentialCountry: json["residential_country"] == null
              ? []
              : List<Interest>.from(json["residential_country"]!
                  .map((x) => Interest.fromJson(x))),
          rating: json["rating"],
          feedback: json["feedback"],
          empCode: json["emp_code"],
          partnerName: json["partner_name"],
          pointBalance: json["point_balance"],
          tentativePoints: json["tentative_points"],
          referralUrl: json["referral_url"],
          expiryMessage: json['expiry_message']);

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "membership_no": membershipNo,
        "country_code": countryCode,
        "mobile_number": mobileNumber,
        "email": email,
        "tier_id": tierId,
        "tier_expiry":
            "${tierExpiry?.year.toString().padLeft(4, '0')}-${tierExpiry?.month.toString().padLeft(2, '0')}-${tierExpiry?.day.toString().padLeft(2, '0')}",
        "account_status": accountStatus,
        "sms_consent": smsConsent,
        "whatsapp_consent": whatsappConsent,
        "email_consent": emailConsent,
        "email_verified": emailVerified,
        "phone_verified": phoneVerified,
        "addr_line_1": addrLine1,
        "addr_line_2": addrLine2,
        "dob": dob,
        "gender": gender,
        "city_id": cityId,
        "nationality": nationality == null
            ? []
            : List<dynamic>.from(nationality!.map((x) => x.toJson())),
        "pin_code": pinCode,
        "image": image,
        "is_uae_resident": isUaeResident,
        "employment_type": employmentType,
        "referral_code": referralCode,
        "city_name": cityName,
        "country_flag": countryFlag,
        "tier": tier,
        "interests": interests == null
            ? []
            : List<dynamic>.from(interests!.map((x) => x.toJson())),
        "residential_country": residentialCountry == null
            ? []
            : List<dynamic>.from(residentialCountry!.map((x) => x.toJson())),
        "rating": rating,
        "feedback": feedback,
        "emp_code": empCode,
        "partner_name": partnerName,
        "point_balance": pointBalance,
        "tentative_points": tentativePoints,
        "referral_url": referralUrl,
        "expiry_message": expiryMessage,
      };
}

class Interest {
  int? id;
  String? name;
  String? image;
  String? code;
  String? imageNew;

  Interest({
    this.id,
    this.name,
    this.image,
    this.code,
    this.imageNew,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        code: json["code"],
        imageNew: json["image_new"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "code": code,
        "image_new": imageNew,
      };
}
