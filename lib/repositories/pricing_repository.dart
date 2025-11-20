class PricingRepository {
  double calculatePrice({required int quantity, required String size}) {
    const sixInchPrice = 7.0;
    const footlongPrice = 11.0;
    
    final pricePerSandwich = size.toLowerCase() == 'footlong' 
        ? footlongPrice 
        : sixInchPrice;
    
    return quantity * pricePerSandwich;
  }
}