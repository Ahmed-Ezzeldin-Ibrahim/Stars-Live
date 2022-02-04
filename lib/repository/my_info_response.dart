// To parse this JSON data, do
//
//     final myInfoResponse = myInfoResponseFromJson(jsonString);

import 'dart:convert';

MyInfoResponse myInfoResponseFromJson(String str) => MyInfoResponse.fromJson(json.decode(str));

class MyInfoResponse {
  MyInfoResponse({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  final String status;
  final Data data;
  final String msg;
  final List<dynamic> errors;

  factory MyInfoResponse.fromJson(Map<String, dynamic> json) => MyInfoResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        msg: json["msg"] == null ? null : json["msg"],
        errors: json["errors"] == null ? null : List<dynamic>.from(json["errors"].map((x) => x)),
      );
}

class Data {
  Data({
    this.currentShiftSalaryTotal,
    this.currentShiftSalaryRemaining,
    this.currentShiftTotalTransferred,
    this.transactions,
  });

  final int currentShiftSalaryTotal;
  final int currentShiftSalaryRemaining;
  final int currentShiftTotalTransferred;
  final List<Transaction> transactions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentShiftSalaryTotal: json["current_shift_salary_total"] == null ? null : json["current_shift_salary_total"],
        currentShiftSalaryRemaining: json["current_shift_salary_remaining"] == null ? null : json["current_shift_salary_remaining"],
        currentShiftTotalTransferred: json["current_shift_total_transferred"] == null ? null : json["current_shift_total_transferred"],
        transactions: json["transactions"] == null ? null : List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
      );
}

class Transaction {
  Transaction({
    this.toId,
    this.toName,
    this.coins,
    this.usd,
    this.time,
  });

  final String toId;
  final String toName;
  final String coins;
  final int usd;
  final String time;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        toId: json["to_id"] == null ? null : json["to_id"],
        toName: json["to_name"] == null ? null : json["to_name"],
        coins: json["coins"] == null ? null : json["coins"],
        usd: json["usd"] == null ? null : json["usd"],
        time: json["time"] == null ? null : "${json["time"]}",
      );
}
