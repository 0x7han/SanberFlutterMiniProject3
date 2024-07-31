import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanber_flutter_mini_project_3/logic/cart_bloc/cart_bloc.dart';
import 'package:sanber_flutter_mini_project_3/model/cart.dart';
import 'package:sanber_flutter_mini_project_3/model/product.dart';
import 'package:sanber_flutter_mini_project_3/repositories/product_repository.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloc _cartBloc;
  @override
  void initState() {
    super.initState();
    _cartBloc = context.read<CartBloc>();
    _cartBloc.add(LoadCarts());
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          centerTitle: true,
        ),
        body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CartLoaded) {
            if (state.carts.length > 1) {
              final Cart carts = state.carts[3];
              return ListTile(
                title: Text('Date : ${carts.date.substring(0, 10)}'),
                subtitle: ListView.builder(
                  itemCount: carts.products.length,
                  itemBuilder: (_, i) {
                    List<dynamic> products = carts.products;

                    return FutureBuilder(
                        future: ProductRepository()
                            .getByIdFromAPI(products[i]['productId']),
                        builder: (_, snapshot) {
                          final Product? product = snapshot.data;
                          if (snapshot.hasData) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Image.network(
                                      product!.image,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '\$ ${product.price}',
                                          style: textTheme.labelLarge!.copyWith(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                            'qty : ${products[i]['quantity']}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        });
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('Data kosong'),
              );
            }
          } else { 
            return const SizedBox();
          }
        }));
  }
}
