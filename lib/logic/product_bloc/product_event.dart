part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class UpdateProducts extends ProductEvent {
  final List<Product> products;

  const UpdateProducts(this.products);

  @override
  List<Object> get props => [products];
}

class ExportToFirestoreProducts extends ProductEvent {

  const ExportToFirestoreProducts();

  @override
  List<Object> get props => [];
}

class ResetFirestoreProducts extends ProductEvent {

  const ResetFirestoreProducts();

  @override
  List<Object> get props => [];
}

