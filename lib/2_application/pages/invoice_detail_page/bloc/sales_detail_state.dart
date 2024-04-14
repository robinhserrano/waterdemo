part of 'sales_detail_cubit.dart';

abstract class SalesDetailCubitState extends Equatable {
  const SalesDetailCubitState();

  @override
  List<Object> get props => [];
}

class SalesDetailInitial extends SalesDetailCubitState {
  const SalesDetailInitial();
}

class SalesDetailStateLoading extends SalesDetailCubitState {
  const SalesDetailStateLoading();
}

class SalesDetailStateLoaded extends SalesDetailCubitState {
  const SalesDetailStateLoaded({required this.salesDetail});
  final SalesEntity salesDetail;

  @override
  List<Object> get props => [salesDetail];
}

class SalesDetailStateError extends SalesDetailCubitState {
  const SalesDetailStateError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
