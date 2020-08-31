class LocalProductModel{

   int id;
   String name;
   int qty;
   double price;
   String image;
  static final columns = ["id", "name", "qty", "price", "image"];
  LocalProductModel(this.id, this.name, this.qty, this.price, this.image);
  factory LocalProductModel.fromMap(Map<String, dynamic> data) {
    return LocalProductModel(
      data['id'],
      data['name'],
      data['qty'],
      data['price'],
      data['image'],
    );
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "qty": qty,
    "price": price,
    "image": image
  };
}

