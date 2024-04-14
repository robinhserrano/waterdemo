import 'package:cloud_firestore/cloud_firestore.dart';

class SalesEntity {
  final String? id;
  final String customerName;
  final String jobNumber;
  final String jobSubmissionTime;
  final String leadSource;
  final String paymentMethod;
  final String systemDetailsAndNote;
  final String address; // Assuming 'place' is a string field
  final num customerContact;

  // Additional fields as needed
  final num cashReceiving; // Nullable for optional field
  final num contractFullPrice; // Nullable for optional field
  final String customerPayment; // Nullable for optional field

  const SalesEntity({
    this.id,
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
  });

  factory SalesEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
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
      if (cashReceiving != null) 'cashReceiving': cashReceiving,
      if (contractFullPrice != null) 'contractFullPrice': contractFullPrice,
      if (customerPayment != null) 'customerPayment': customerPayment,
    };
  }

  // Add methods for editing specific fields (e.g., editCashReceiving)
}
