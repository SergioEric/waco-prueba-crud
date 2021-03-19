import 'package:crud_productos/app/login/login.page.dart';
import 'package:crud_productos/widgets/show.snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/product.form.provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crud_productos/models/product.dart';
import 'package:crud_productos/services/database.dart';
import 'package:crud_productos/widgets/alert.dialog.exception.dart';

enum ProductAction {
  edit,
  create,
}

class HandleProductAction extends HookWidget {
  HandleProductAction({
    this.product,
    required this.action,
    required this.database,
    required this.onDeleted,
  }) : assert(
          action == ProductAction.create || product != null,
          'for editing a product, you must provide an instance',
        );
  final Database database;
  final Product? product;
  final ProductAction action;
  final VoidCallback onDeleted;

  Future<void> createNewProduct(BuildContext context) async {
    final isOk = context.read(ProductFormProvider).validatedState();
    print("isOk $isOk");
    if (isOk) {
      final _product = context.read(ProductFormProvider).product;
      try {
        await database.createProduct(_product);
        await showSnackBar(
          context: context,
          content: Text("Contenido Guardado"),
        );
        await Future.delayed(const Duration(milliseconds: 1200));
        Navigator.canPop(context);
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Ups!',
          exception: e,
        );
      }
    }
    return;
  }

  Future<void> editProduct(BuildContext context) async {
    final isOk = context.read(ProductFormProvider).validatedState();
    print("isOk $isOk");
    if (isOk) {
      final _product = context.read(ProductFormProvider).product;
      try {
        await database.updatedProduct(_product);
        await showSnackBar(
          context: context,
          content: Text("Contenido Guardado"),
        );
        await Future.delayed(const Duration(milliseconds: 1200));
        // Navigator.pop(context);
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Ups!',
          exception: e,
        );
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    print(action == ProductAction.create || product != null);
    useEffect(() {
      // if we are updating the product, we have to update
      // the product id once we enter in this page
      if (action == ProductAction.edit) {
        // context.read(ProductFormProvider).changeId(product!.id);
        // then we updated the other products field
        WidgetsBinding.instance!.addPostFrameCallback(
          (_) => context.read(ProductFormProvider).product = product!,
        );
      }
    }, []);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final nameCtrl = useTextEditingController(text: product?.name ?? '');
    final priceCtrl =
        useTextEditingController(text: product?.price.toString() ?? '');
    final stockCtrl =
        useTextEditingController(text: product?.stock.toString() ?? '');
    final descriptionCtrl =
        useTextEditingController(text: product?.description ?? '');
    return WillPopScope(
      onWillPop: () async {
        context.read(ProductFormProvider).clean();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: action == ProductAction.create
              ? const Text("Crea un nuevo producto")
              : const Text("... editando"),
          actions: [
            if (action == ProductAction.edit) ...[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onDeleted,
              )
            ],
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (action == ProductAction.create) {
                  createNewProduct(context);
                  return;
                }
                editProduct(context);
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                color: theme.colorScheme.surface,
                child: TextFormField(
                  controller: nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    context.read(ProductFormProvider).onNameChanged(val);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                color: theme.colorScheme.surface,
                child: TextFormField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    // hintText: "precio",
                    labelText: "precio",
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny("."),
                    FilteringTextInputFormatter.deny(","),
                    FilteringTextInputFormatter.deny(" "),
                    FilteringTextInputFormatter.deny("-"),
                    FilteringTextInputFormatter.allow(
                      RegExp(r"^\d+\.?\d{0,2}"),
                    ),
                    FilteringTextInputFormatter.deny(
                      RegExp(r"^0+(?!$)"),
                    ),
                  ],
                  onChanged: (val) {
                    context.read(ProductFormProvider).onPriceChanged(val);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                color: theme.colorScheme.surface,
                child: TextFormField(
                  controller: stockCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    // hintText: "stock",
                    labelText: "stock",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny("."),
                    FilteringTextInputFormatter.deny(","),
                    FilteringTextInputFormatter.deny(" "),
                    FilteringTextInputFormatter.deny("-"),
                    FilteringTextInputFormatter.allow(
                      RegExp(r"^\d+\.?\d{0,2}"),
                    ),
                    FilteringTextInputFormatter.deny(
                      RegExp(r"^0+(?!$)"),
                    ),
                  ],
                  onChanged: (val) {
                    context.read(ProductFormProvider).onStockChanged(val);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Material(
                  color: theme.colorScheme.surface,
                  elevation: 12,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      // autofocus: true,
                      controller: descriptionCtrl,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration.collapsed(
                        hintText:
                            "...descripción \n ...\n ....\n .....\n ......",
                      ),
                      onChanged: (val) {
                        context
                            .read(ProductFormProvider)
                            .onDescriptionChanged(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
