part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCarts extends CartEvent {}

class UpdateCarts extends CartEvent {
  final List<Cart> carts;

  const UpdateCarts(this.carts);

  @override
  List<Object> get props => [carts];
}

class ExportToFirestoreCarts extends CartEvent {

  const ExportToFirestoreCarts();

  @override
  List<Object> get props => [];
}

class ResetFirestoreCarts extends CartEvent {

  const ResetFirestoreCarts();

  @override
  List<Object> get props => [];
}

