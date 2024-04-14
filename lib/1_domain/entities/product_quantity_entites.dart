class ProductQuantity {
  ProductQuantity(this.product, this.quantity);
  String product;
  double quantity;
}

String formatProductQuantities(List<ProductQuantity> quantities) {
  return quantities.map((pq) => '${pq.product}: ${pq.quantity}').join(',');
}

List<ProductQuantity> parseProductQuantities(String dataString) {
  final productQuantities = <ProductQuantity>[];
  for (final item in dataString.split(',')) {
    final parts = item.trim().split(':');
    if (parts.length == 2) {
      final productName = parts[0].trim();
      final quantity = double.tryParse(parts[1].trim()) ?? 0.0;
      productQuantities.add(ProductQuantity(productName, quantity));
    }
  }
  return productQuantities;
}
