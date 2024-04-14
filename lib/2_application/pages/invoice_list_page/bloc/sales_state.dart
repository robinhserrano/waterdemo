part of 'sales_cubit.dart';

abstract class SalesCubitState extends Equatable {
  const SalesCubitState();

  @override
  List<Object> get props => [];
}

class SalesInitial extends SalesCubitState {
  const SalesInitial();
}

class SalesStateLoading extends SalesCubitState {
  const SalesStateLoading();
}

class SalesStateLoaded extends SalesCubitState {
  const SalesStateLoaded({required this.sales});
  final List<SalesEntity> sales;

  @override
  List<Object> get props => [sales];
}

class SalesStateError extends SalesCubitState {
  const SalesStateError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
