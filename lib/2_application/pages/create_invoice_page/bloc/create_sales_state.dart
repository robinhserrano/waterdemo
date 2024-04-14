part of 'create_sales_cubit.dart';

abstract class CreateSalesCubitState extends Equatable {
  const CreateSalesCubitState();

  @override
  List<Object> get props => [];
}

class CreateSalesInitial extends CreateSalesCubitState {
  const CreateSalesInitial();
}

class CreateSalesStateLoading extends CreateSalesCubitState {
  const CreateSalesStateLoading();
}

class CreateSalesStateSaved extends CreateSalesCubitState {
  const CreateSalesStateSaved();

  @override
  List<Object> get props => [];
}

class CreateSalesStateError extends CreateSalesCubitState {
  const CreateSalesStateError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}
