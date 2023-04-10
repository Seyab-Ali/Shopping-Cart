
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/db_helper.dart';

import 'cart_model.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbHelpher = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
              badgeAnimation: const BadgeAnimation.slide(
                  animationDuration: Duration(seconds: 2)),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: ((context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data!.isEmpty){
                      return Center(
                        child: Text('Cart is Empty')
                      );
                    }
                    else{
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        Image(
                                          height: 100,
                                          width: 100,
                                          image: NetworkImage(snapshot
                                              .data![index].image
                                              .toString()),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data![index].productName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        dbHelpher!.delete(snapshot
                                                            .data![index].id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .productPrice
                                                                .toString()));
                                                      },
                                                      child: Icon(Icons.delete)),
                                                ],
                                              ),
                                              Text(
                                                snapshot.data![index].unitTag
                                                    .toString() +
                                                    " " +
                                                    'RS ' +
                                                    snapshot
                                                        .data![index].productPrice
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              // Align(
                                              //     alignment: Alignment.centerRight,
                                              //     child: InkWell(
                                              //       onTap: () {},
                                              //       child: Container(
                                              //         height: 35,
                                              //         width: 100,
                                              //         decoration: BoxDecoration(
                                              //             borderRadius:
                                              //             BorderRadius.circular(
                                              //                 14),
                                              //             color: Colors.green),
                                              //         child: const Center(
                                              //           child: Text(
                                              //             "Add to Cart",
                                              //             style: TextStyle(
                                              //                 color: Colors.white),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                  }

                  return Text('No Data');
                })),
            Consumer<CartProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
                  child: Column(
                    children: [
                      ReuseWidget(
                          title: 'Sub Total:',
                          value: 'Rs ' + value.getTotalPrice().toStringAsFixed(2)),
                      ReuseWidget(
                          title: 'Discount 7%:',
                          value: 'Rs ' + '14.00'),
                      ReuseWidget(
                          title: 'Total:',
                          value: 'Rs ' + value.getTotalPrice().toStringAsFixed(2) )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ReuseWidget extends StatelessWidget {
  final String title, value;

  const ReuseWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}
