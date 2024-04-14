import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_filter/0_data/repositories/repository.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
part 'sales_state.dart';

class SalesCubit extends Cubit<SalesCubitState> {
  SalesCubit({required this.firestoreService})
      : super(const SalesStateLoading()) {
    fetchSales();
  }

  final FirebaseFirestoreService firestoreService;

  Future<void> fetchSales() async {
    try {
      emit(const SalesStateLoading());
      final sales = await firestoreService.getSales();
      emit(SalesStateLoaded(sales: sales));
    } on Exception catch (error) {
      emit(SalesStateError(message: error.toString()));
    } catch (e) {
      emit(SalesStateError(message: e.toString()));
    }
  }
}
