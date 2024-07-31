import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanber_flutter_mini_project_3/helper/notification_helper.dart';
import 'package:sanber_flutter_mini_project_3/logic/auth_bloc/auth_bloc.dart';
import 'package:sanber_flutter_mini_project_3/logic/cart_bloc/cart_bloc.dart';
import 'package:sanber_flutter_mini_project_3/logic/product_bloc/product_bloc.dart';
import 'package:sanber_flutter_mini_project_3/model/product.dart';
import 'package:sanber_flutter_mini_project_3/ui/screens/cart_screen.dart';
import 'package:sanber_flutter_mini_project_3/ui/screens/product_detail_screen.dart';
import 'package:sanber_flutter_mini_project_3/ui/screens/profile_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

    Future<void> sendLocalNotification() async {
    NotificationHelper.payload.value = '';

    await NotificationHelper.flutterLocalNotificationsPlugin.show(
        1,
        "Rpedia",
        "Halo Raihan, ada barang rekomend nihh.. Buruan checkout",
        NotificationHelper.notificationDetails);
  }
  
  late ProductBloc _productBloc;
  @override
  void initState() {
    super.initState();
    _productBloc = context.read<ProductBloc>();
    _productBloc.add(LoadProducts());
    sendLocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag,
                color: colorScheme.primary,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'Rpedia',
                style:
                    textTheme.titleLarge!.copyWith(color: colorScheme.primary),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const CartScreen())),
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(uid: state.uid))),
                    icon: const Icon(Icons.person_outline),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductLoaded) {
            final List<Product> products = state.products;
            if (products.length > 1) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                        product: products[index]))),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 16),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 100,
                                    child: Image.network(
                                      products[index].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index].category,
                                        style: textTheme.labelMedium!.copyWith(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.5)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        products[index].title,
                                        style: textTheme.titleMedium!.copyWith(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$ ${products[index].price}',
                                        style: textTheme.titleMedium!.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                          ),
                                          Text(
                                            products[index]
                                                .rating['rate']
                                                .toString(),
                                            style: textTheme.labelMedium!
                                                .copyWith(
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.5)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Icon(
                                              Icons.brightness_1,
                                              size: 4,
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          Text(
                                            '${products[index].rating['count'].toString()} sold',
                                            style: textTheme.labelMedium!
                                                .copyWith(
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.5)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    color: colorScheme.primaryContainer.withOpacity(0.8),
                    child: FilledButton.tonal(
                        onPressed: () {
                          _productBloc.add(const ResetFirestoreProducts());
                          context.read<CartBloc>().add(const ResetFirestoreCarts());
                        },
                        child: const Text('Reset')),
                  ),
                ],
              );
            } else {
              return Center(
                  child: FilledButton.tonal(
                      onPressed: () {
                        _productBloc.add(const ExportToFirestoreProducts());
                        context.read<CartBloc>().add(const ExportToFirestoreCarts());
                      },
                      child: const Text('Export')));
            }
          } else {
            return Center(
                child: FilledButton.tonal(
                    onPressed: () {
                      _productBloc.add(const ExportToFirestoreProducts());
                      context.read<CartBloc>().add(const ExportToFirestoreCarts());
                    },
                    child: const Text('Export')));
          }
        }));
  }
}
