import 'package:crud_productos/brand/brand.dart';
import 'package:crud_productos/helpers/string.extensions.dart';
import 'package:crud_productos/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductItem extends StatelessWidget {
  ProductItem({
    required this.product,
    required this.onTap,
    required this.onDeleted,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[],
      secondaryActions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              primary: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete),
                Text('Borrar'),
              ],
            ),
            onPressed: onDeleted,
          ),
        ),
        // Text("secondaryActions 2"),
      ],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Material(
          color: Colors.white,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            onTap: onTap,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product.stock.toString().formatPrice),
                Text(
                  "en stock",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            title: Text(
              product.name,
              style: textTheme.headline6,
            ),
            subtitle: Text(
              product.description.removeEmptySpaces.clipDescription,
              style: textTheme.caption,
            ),
            trailing: Container(
              padding: EdgeInsets.all(4),
              child: Text(
                product.price.toString().formatPrice.addCurrencySign,
                style: textTheme.subtitle2!.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryVariant.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
