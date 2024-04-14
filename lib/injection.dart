import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
// import 'package:sprout_mobile_exam_serrano/0_data/datasources/product_remote_datasource.dart';
// import 'package:sprout_mobile_exam_serrano/0_data/repositories/product_repo_impl.dart';
// import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/repositories/product_repo.dart';
// import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_details_usecases.dart';
// import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/usecases/product_usecases.dart';
// import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/cubit/product_details_cubit.dart';
// import 'package:sprout_mobile_exam_serrano/2_application/pages/products/cubit/products_cubit.dart';
import 'package:water_filter/0_data/repositories/repository.dart';
import 'package:water_filter/2_application/pages/create_invoice_page/bloc/create_sales_cubit.dart';
import 'package:water_filter/2_application/pages/invoice_detail_page/bloc/sales_detail_cubit.dart';
import 'package:water_filter/2_application/pages/invoice_list_page/bloc/sales_cubit.dart';

final sl = GetIt.I; // sl == Service Locator

Future<void> init() async {
// ! application Layer
  // Factory = every time a new/fresh instance of that class
  sl
    ..registerFactory(() => SalesCubit(firestoreService: sl()))
    ..registerFactory(() => SalesDetailCubit(firestoreService: sl()))
    ..registerFactory(() => CreateSalesCubit(firestoreService: sl()))
//     ..registerFactory(() => ProductDetailsCubit(productDetailsUseCases: sl()))

// // ! domain Layer
    ..registerFactory(() => FirebaseFirestoreService());
//     ..registerFactory(() => ProductDetailsUseCases(productRepo: sl()))

// // ! data Layer
//     ..registerFactory<ProductRepo>(
//       () => ProductRepoImpl(productRemoteDatasource: sl()),
//     )
//     ..registerFactory<ProductRemoteDatasource>(
//       () => ProductRemoteDatasourceImpl(client: sl()),
//     )

// // ! externs
//     ..registerFactory(Dio.new);
}
