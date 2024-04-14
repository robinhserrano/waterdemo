import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_filter/0_data/repositories/repository.dart';
import 'package:water_filter/1_domain/entities/sales_entities.dart';
import 'package:water_filter/2_application/core/helpers.dart';
part 'create_sales_state.dart';

class CreateSalesCubit extends Cubit<CreateSalesCubitState> {
  CreateSalesCubit({required this.firestoreService})
      : super(const CreateSalesStateLoading());

  final FirebaseFirestoreService firestoreService;

  Future<void> createSales(SalesEntity sale) async {
    try {
      emit(const CreateSalesStateLoading());
      final sales = await firestoreService.getSales();

      final allJobNumbers = sales.map((entity) => entity.jobNumber).toList();

      final highestNumber = getHighestJobNumber(allJobNumbers) + 1;

      final createSales = await firestoreService
          .createSales(sale.copyWith(jobNumber: 'S0$highestNumber'));
      if (createSales) {
        emit(const CreateSalesStateSaved());
      } else {
        emit(const CreateSalesStateError(message: 'Data Not Found'));
      }
    } on Exception catch (error) {
      emit(CreateSalesStateError(message: error.toString()));
    } catch (e) {
      emit(CreateSalesStateError(message: e.toString()));
    }
  }
}
