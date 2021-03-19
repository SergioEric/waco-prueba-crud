class APIPath {
  // uid = user id for storing the products
  // products created with Auto-ID
  static String product(String uid) => 'products/$uid/list';

  // products updated needs the ID
  static String productWithId(String uid, String productId) => 'products/$uid/list/$productId';

}
