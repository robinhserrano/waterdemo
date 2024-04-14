import 'package:cloud_firestore/cloud_firestore.dart';

class SalesEntity {
  const SalesEntity({
    required this.customerName,
    required this.jobNumber,
    required this.jobSubmissionTime,
    required this.leadSource,
    required this.paymentMethod,
    required this.systemDetailsAndNote,
    required this.address,
    required this.customerContact,
    required this.cashReceiving,
    required this.contractFullPrice,
    required this.customerPayment,
    this.id,
  });

  factory SalesEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return SalesEntity(
      id: snapshot.id,
      customerName: data['customerName'] as String,
      customerContact: data['customerContact'] as num,
      jobNumber: data['jobNumber'] as String,
      jobSubmissionTime: data['jobSubmissionTime'] as String,
      leadSource: data['leadSource'] as String,
      paymentMethod: data['paymentMethod'] as String,
      systemDetailsAndNote: data['systemDetailsAndNote'] as String,
      address: data['address'] as String,
      cashReceiving: data['cashReceiving'] as num,
      contractFullPrice: data['contractFullPrice'] as num,
      customerPayment: data['customerPayment'] as String,
    );
  }
  final String? id;
  final String customerName;
  final String jobNumber;
  final String jobSubmissionTime;
  final String leadSource;
  final String paymentMethod;
  final String systemDetailsAndNote;
  final String address;
  final num customerContact;
  final num cashReceiving;
  final num contractFullPrice;
  final String customerPayment;

  SalesEntity copyWith({
    String? id,
    String? customerName,
    String? jobNumber,
    String? jobSubmissionTime,
    String? leadSource,
    String? paymentMethod,
    String? systemDetailsAndNote,
    String? address,
    num? customerContact,
    num? cashReceiving,
    num? contractFullPrice,
    String? customerPayment,
  }) {
    return SalesEntity(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      jobNumber: jobNumber ?? this.jobNumber,
      jobSubmissionTime: jobSubmissionTime ?? this.jobSubmissionTime,
      leadSource: leadSource ?? this.leadSource,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      systemDetailsAndNote: systemDetailsAndNote ?? this.systemDetailsAndNote,
      address: address ?? this.address,
      customerContact: customerContact ?? this.customerContact,
      cashReceiving: cashReceiving ?? this.cashReceiving,
      contractFullPrice: contractFullPrice ?? this.contractFullPrice,
      customerPayment: customerPayment ?? this.customerPayment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'jobNumber': jobNumber,
      'jobSubmissionTime': jobSubmissionTime,
      'leadSource': leadSource,
      'paymentMethod': paymentMethod,
      'systemDetailsAndNote': systemDetailsAndNote,
      'address': address,
      'customerContact': customerContact,
      'cashReceiving': cashReceiving,
      'contractFullPrice': contractFullPrice,
      'customerPayment': customerPayment,
    };
  }
}
