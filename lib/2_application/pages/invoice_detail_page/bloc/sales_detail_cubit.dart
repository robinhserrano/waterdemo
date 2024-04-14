import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_filter/0_data/repositories/repository.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
part 'sales_detail_state.dart';

class SalesDetailCubit extends Cubit<SalesDetailCubitState> {
  SalesDetailCubit({required this.firestoreService})
      : super(const SalesDetailStateLoading());

  final FirebaseFirestoreService firestoreService;

  Future<void> fetchSalesDetail(String id) async {
    try {
      emit(const SalesDetailStateLoading());
      final salesDetail = await firestoreService.getSaleById(id);
      if (salesDetail != null) {
        emit(SalesDetailStateLoaded(salesDetail: salesDetail));
      } else {
        emit(const SalesDetailStateError(message: 'Data Not Found'));
      }
    } on Exception catch (error) {
      emit(SalesDetailStateError(message: error.toString()));
    } catch (e) {
      emit(SalesDetailStateError(message: e.toString()));
    }
  }
}
