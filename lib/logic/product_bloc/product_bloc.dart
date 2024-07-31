import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sanber_flutter_mini_project_3/model/product.dart';
import 'package:sanber_flutter_mini_project_3/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription<List<Product>>? _productSubscription;

  ProductBloc({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepository(),
        super(ProductLoading()) {
          
    on<LoadProducts>((event, emit) {
      _productSubscription?.cancel();
      _productSubscription = _productRepository.get().listen(
            (products) => add(UpdateProducts(products)),
          );
    });

    on<UpdateProducts>((event, emit) {
      List<Product> sortedProducts = event.products;
      emit(ProductLoaded(products: sortedProducts));
    });


    on<ExportToFirestoreProducts>((event, emit) async {
      await _productRepository.exportToFirestore();

    });

    on<ResetFirestoreProducts  >((event, emit) async {

      await _productRepository.resetFirestore();
      emit(ProductInitial());
    });
   
  }



  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}


