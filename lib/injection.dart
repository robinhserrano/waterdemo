import 'package:get_it/get_it.dart';
import 'package:water_filter/0_data/repositories/repository.dart';
import 'package:water_filter/2_application/pages/create_invoice_page/bloc/create_sales_cubit.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/bloc/sales_detail_cubit.dart';
import 'package:water_filter/2_application/pages/invoice_list_page/bloc/sales_cubit.dart';

final sl = GetIt.I; // sl == Service Locator

Future<void> init() async {
  sl
    ..registerFactory(() => SalesCubit(firestoreService: sl()))
    ..registerFactory(() => SalesDetailCubit(firestoreService: sl()))
    ..registerFactory(() => CreateSalesCubit(firestoreService: sl()))
    ..registerFactory(FirebaseFirestoreService.new);
}
