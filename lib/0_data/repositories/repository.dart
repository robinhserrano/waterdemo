import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'sales';

  Future<bool> createSales(SalesEntity job) async {
    try {
      final docRef = _firestore.collection(_collectionPath).doc();
      await docRef.set(job.toJson());
      return true;
    } on FirebaseException catch (e) {
      throw Exception(
        'Failed to add job: ${e.message}',
      );
    }
  }

  Future<List<SalesEntity>> getSales() async {
    final querySnapshot = await _firestore.collection(_collectionPath).get();
    final jobs = querySnapshot.docs.map(SalesEntity.fromFirestore).toList();
    return jobs;
  }

  Future<SalesEntity?> getSaleById(String id) async {
    final docSnapshot =
        await _firestore.collection(_collectionPath).doc(id).get();
    if (docSnapshot.exists) {
      return SalesEntity.fromFirestore(docSnapshot);
    } else {
      return null;
    }
  }

  Future<bool> deleteSaleById(String saleId) async {
    try {
      final docRef = _firestore.collection(_collectionPath).doc(saleId);
      await docRef.delete();
      return true;
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete job: ${e.message}');
    } catch (_) {
      return false;
    }
  }
}
