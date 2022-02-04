class TopUsers {
  TopUsers({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  String status;
  List<Datum> data;
  String msg;
  List<dynamic> errors;

  factory TopUsers.fromJson(Map<String, dynamic> json) => TopUsers(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        msg: json["msg"],
        errors: List<dynamic>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
        "errors": List<dynamic>.from(errors.map((x) => x)),
      };
}

class Datum {
  Datum({
    this.user,
    this.value,
  });

  User user;
  int value;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        user: User.fromJson(json["user"]),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "value": value,
      };
}

class User {
  User({
    this.id,
    this.type,
    this.name,
    this.email,
    this.phone,
    this.isOnline,
    this.isLive,
    this.whats,
    this.country,
    this.image,
    this.gender,
    this.followed,
    this.salary,
    this.balanceInCoins,
    this.diamonds,
    this.totalReceivedGifts,
    this.apiToken,
    this.levelHost,
    this.levelUser,
    this.followers,
    this.followeds,
  });

  int id;
  String type;
  String name;
  String email;
  String phone;
  int isOnline;
  int isLive;
  dynamic whats;
  String country;
  String image;
  String gender;
  String followed;
  double salary;
  int balanceInCoins;
  int diamonds;
  int totalReceivedGifts;
  dynamic apiToken;
  Level levelHost;
  Level levelUser;
  List<Follower> followers;
  List<Follower> followeds;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        isOnline: json["is_online"] == null ? null : int.parse(json["is_online"]),
        isLive: json["is_live"],
        whats: json["whats"],
        country: json["country"],
        image: json["image"],
        gender: json["gender"],
        followed: json["followed"],
        salary: json["salary"].toDouble(),
        balanceInCoins: int.parse('${json["balance_in_coins"]}'),
        diamonds: json["diamonds"],
        totalReceivedGifts: json["total_received_gifts"],
        apiToken: json["api_token"],
        levelHost: Level.fromJson(json["level_host"]),
        levelUser: Level.fromJson(json["level_user"]),
        followers: json["followers"] != null ? List<Follower>.from(json["followers"].map((x) => Follower.fromJson(x))) : null,
        followeds: json["followeds"] != null ? List<Follower>.from(json["followeds"].map((x) => Follower.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "email": email,
        "phone": phone,
        "is_online": isOnline,
        "is_live": isLive,
        "whats": whats,
        "country": country,
        "image": image,
        "gender": gender,
        "followed": followed,
        "salary": salary,
        "balance_in_coins": balanceInCoins,
        "diamonds": diamonds,
        "total_received_gifts": totalReceivedGifts,
        "api_token": apiToken,
        "level_host": levelHost.toJson(),
        "level_user": levelUser.toJson(),
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "followeds": List<dynamic>.from(followeds.map((x) => x.toJson())),
      };
}

class Follower {
  Follower({
    this.id,
    this.roleId,
    this.agancyId,
    this.name,
    this.blocked,
    this.gender,
    this.country,
    this.email,
    this.phone,
    this.facebookId,
    this.googleId,
    this.avatar,
    this.idImage,
    this.emailVerifiedAt,
    this.deviceToken,
    this.settings,
    this.currentUsd,
    this.currentCoins,
    this.currentGifts,
    this.totalReceivedCoins,
    this.latitude,
    this.longitude,
    this.isOnline,
    this.isLive,
    this.liveType,
    this.liveToken,
    this.rtmToken,
    this.image,
    this.type,
    this.followed,
    this.whatsApp,
    this.diamonds,
    this.salary,
    this.agencyAmount,
    this.shiftTrxsAmount,
    this.levelHost,
    this.levelUser,
    this.banedFromWriting,
    this.banedFromBroadcasting,
    this.pivot,
    this.role,
    this.roles,
    this.scores,
  });

  int id;
  int roleId;
  dynamic agancyId;
  String name;
  int blocked;
  String gender;
  String country;
  String email;
  String phone;
  dynamic facebookId;
  dynamic googleId;
  String avatar;
  dynamic idImage;
  dynamic emailVerifiedAt;
  dynamic deviceToken;
  List<dynamic> settings;
  int currentUsd;
  int currentCoins;
  int currentGifts;
  int totalReceivedCoins;
  String latitude;
  String longitude;
  int isOnline;
  int isLive;
  dynamic liveType;
  dynamic liveToken;
  dynamic rtmToken;
  String image;
  String type;
  String followed;
  dynamic whatsApp;
  int diamonds;
  double salary;
  String agencyAmount;
  String shiftTrxsAmount;
  Level levelHost;
  Level levelUser;
  bool banedFromWriting;
  bool banedFromBroadcasting;
  Pivot pivot;
  Role role;
  List<dynamic> roles;
  List<dynamic> scores;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["id"],
        roleId: json["role_id"],
        agancyId: json["agancy_id"],
        name: json["name"],
        blocked: json["blocked"],
        gender: json["gender"],
        country: json["country"],
        email: json["email"],
        phone: json["phone"],
        facebookId: json["facebook_id"],
        googleId: json["google_id"],
        avatar: json["avatar"],
        idImage: json["id_image"],
        emailVerifiedAt: json["email_verified_at"],
        deviceToken: json["device_token"],
        // settings: List<dynamic>.from(json["settings"].map((x) => x)),
        currentUsd: json["current_usd"],
        currentCoins: json["current_coins"],
        currentGifts: json["current_gifts"],
        totalReceivedCoins: json["total_received_coins"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isOnline: json["is_online"] == null ? null : int.parse(json["is_online"]),
        isLive: json["is_live"] == null ? null : int.parse('${json["is_live"]}'),
        liveType: json["live_type"],
        liveToken: json["live_token"],
        rtmToken: json["rtm_token"],
        image: json["image"],
        type: json["type"],
        followed: json["followed"],
        whatsApp: json["whats_app"],
        diamonds: json["diamonds"],
        salary: json["salary"].toDouble(),
        /*agencyAmount: json["agency_amount"],*/
        shiftTrxsAmount: json["shift_trxs_amount"],
        levelHost: Level.fromJson(json["level_host"]),
        levelUser: Level.fromJson(json["level_user"]),
        banedFromWriting: json["baned_from_writing"],
        banedFromBroadcasting: json["baned_from_broadcasting"],
        pivot: Pivot.fromJson(json["pivot"]),
        role: Role.fromJson(json["role"]),
        roles: List<dynamic>.from(json["roles"].map((x) => x)),
        scores: List<dynamic>.from(json["scores"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "agancy_id": agancyId,
        "name": name,
        "blocked": blocked,
        "gender": gender,
        "country": country,
        "email": email,
        "phone": phone,
        "facebook_id": facebookId,
        "google_id": googleId,
        "avatar": avatar,
        "id_image": idImage,
        "email_verified_at": emailVerifiedAt,
        "device_token": deviceToken,
        "settings": List<dynamic>.from(settings.map((x) => x)),
        "current_usd": currentUsd,
        "current_coins": currentCoins,
        "current_gifts": currentGifts,
        "total_received_coins": totalReceivedCoins,
        "latitude": latitude,
        "longitude": longitude,
        "is_online": isOnline,
        "is_live": isLive,
        "live_type": liveType,
        "live_token": liveToken,
        "rtm_token": rtmToken,
        "image": image,
        "type": type,
        "followed": followed,
        "whats_app": whatsApp,
        "diamonds": diamonds,
        "salary": salary,
        "agency_amount": agencyAmount,
        "shift_trxs_amount": shiftTrxsAmount,
        "level_host": levelHost.toJson(),
        "level_user": levelUser.toJson(),
        "baned_from_writing": banedFromWriting,
        "baned_from_broadcasting": banedFromBroadcasting,
        "pivot": pivot.toJson(),
        "role": role.toJson(),
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "scores": List<dynamic>.from(scores.map((x) => x)),
      };
}

class Level {
  Level({
    this.level,
    this.previous,
    this.current,
    this.next,
    this.remaining,
    this.value,
  });

  int level;
  double previous;
  int current;
  double next;
  double remaining;
  double value;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        level: json["level"],
        previous: json["previous"].toDouble(),
        current: json["current"],
        next: json["next"].toDouble(),
        remaining: json["remaining"].toDouble(),
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "previous": previous,
        "current": current,
        "next": next,
        "remaining": remaining,
        "value": value,
      };
}

class Pivot {
  Pivot({
    this.followerId,
    this.followedId,
  });

  int followerId;
  int followedId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        followerId: json["follower_id"],
        followedId: json["followed_id"],
      );

  Map<String, dynamic> toJson() => {
        "follower_id": followerId,
        "followed_id": followedId,
      };
}

class Role {
  Role({
    this.id,
    this.name,
    this.displayName,
  });

  int id;
  String name;
  String displayName;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_name": displayName,
      };
}
