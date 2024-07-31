import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sanber_flutter_mini_project_3/model/cart.dart';
import 'package:sanber_flutter_mini_project_3/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  StreamSubscription<List<Cart>>? _cartSubscription;

  CartBloc({CartRepository? cartRepository})
      : _cartRepository = cartRepository ?? CartRepository(),
        super(CartLoading()) {
          
    on<LoadCarts>((event, emit) {
      _cartSubscription?.cancel();
      _cartSubscription = _cartRepository.get().listen(
            (carts) => add(UpdateCarts(carts)),
          );
    });

    on<UpdateCarts>((event, emit) {
      List<Cart> sortedCarts = event.carts;
      emit(CartLoaded(carts: sortedCarts));
    });


    on<ExportToFirestoreCarts>((event, emit) async {
      await _cartRepository.exportToFirestore();

    });

    on<ResetFirestoreCarts  >((event, emit) async {

      await _cartRepository.resetFirestore();
      emit(CartInitial());
    });
   
  }



  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}


