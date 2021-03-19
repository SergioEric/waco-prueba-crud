//
import 'package:crud_productos/app/product/handle.product.action.dart';
import 'package:crud_productos/app/product/product.item.dart';
import 'package:crud_productos/models/product.dart';
import 'package:crud_productos/services/database.dart';
import 'package:crud_productos/widgets/alert.dialog.exception.dart';
import 'package:crud_productos/widgets/show.snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../global_pods/providers.dart';
import '../login/login.page.dart';
import 'list.item.builder.dart';

final firestoreProvider =
    StateProvider.family<FirestoreDatabase, String>((ref, uid) {
  return FirestoreDatabase(uid: uid);
});

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Database database;

  @override
  void initState() {
    super.initState();
    database = context
        .read(firestoreProvider(
          context.read(authProvider).currentUser!.uid,
        ))
        .state;
    print("currentUser --> ${context.read(authProvider).currentUser!.uid}");
  }

  Future<void> _deleteEntry(Product product) async {
    try {
      await database.deletedProduct(product);
      showSnackBar(
        context: context,
        content: Text("Producto borrado"),
      );
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Ups!',
        exception: e,
      );
    }
  }

  Future<void> createRadomProduct() async {
    try {
      await database.createProduct(
        Product(
          id: "id",
          name: "Some name",
          description: "Some description",
          stock: 23,
          price: 3450,
        ),
      );
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Ups!',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final brightness = theme.brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        brightness: theme.brightness,
        title: Text("Waco Services"),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await context.read(authProvider).signOut();
            },
            icon: Icon(Icons.logout),
            label: Text('logout'),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<List<Product>>(
              stream: database.productsStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                return ListItemsBuilder<Product>(
                  snapshot: snapshot,
                  itemBuilder: (_, product) {
                    return ProductItem(
                      product: product,
                      onDeleted: () => _deleteEntry(product),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HandleProductAction(
                              action: ProductAction.edit,
                              database: database,
                              product: product,
                              onDeleted: () => _deleteEntry(product),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HandleProductAction(
                action: ProductAction.create,
                database: database,
                onDeleted: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
