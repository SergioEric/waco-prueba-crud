extension StringHelper on String {
  String get clipDescription {
    if (isEmpty) return 'Producto sin descripción';

    String clipped = this;

    if (clipped.length >= 100) {
      clipped = clipped.substring(0, 100).split('\n').join();
    }
    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more
    final pattern = RegExp('\\s+');
    return clipped.replaceAll(pattern, ' ').trim();
  }

  String get removeEmptySpaces {
    if (isEmpty) return '';

    final String clipped = this;

    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more
    final pattern = RegExp('\\s+');
    return clipped.replaceAll(pattern, ' ').trim();
  }

  /// extension for formating number into COL currency
  String get formatPrice {
    if (isEmpty) return '';

    // ignore: non_constant_identifier_names
    final String string_price = this;

    final List<String> formatted = string_price.split("");

    if (string_price.length == 8) {
      // 99999999 : 99.999.999
      formatted.insert(2, ".");
      formatted.insert(6, ".");
    } else if (string_price.length == 7) {
      // 9999999 :9.999.999
      formatted.insert(1, ".");
      formatted.insert(5, ".");
    } else if (string_price.length == 6) {
      // 999999 : 999.999
      formatted.insert(3, ".");
    } else if (string_price.length == 5) {
      // 99999 : 99.999
      formatted.insert(2, ".");
    } else if (string_price.length == 4) {
      // 9999 : 9.999
      formatted.insert(1, ".");
    }
    return formatted.join("");
  }

  String get addCurrencySign {
    return "\$ $this".removeEmptySpaces;
  }
}
