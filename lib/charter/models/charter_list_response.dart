class CharterListResponse {
  List<CharterData>? data;
  String? errorFlag;
  String? message;

  CharterListResponse({this.data, this.errorFlag, this.message});

  CharterListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CharterData>[];
      json['data'].forEach((v) {
        data?.add(CharterData.fromJson(v));
      });
    }
    errorFlag = json['error_flag'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['error_flag'] = errorFlag;
    data['message'] = message;
    return data;
  }
}

class CharterData {
  String? chartererId;
  String? chartererName;
  String? tier;

  CharterData({this.chartererId, this.chartererName, this.tier});

  CharterData.fromJson(Map<String, dynamic> json) {
    chartererId = json['chartererId'];
    chartererName = json['chartererName'];
    tier = json['Tier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chartererId'] = chartererId;
    data['chartererName'] = chartererName;
    data['Tier'] = tier;
    return data;
  }
}
