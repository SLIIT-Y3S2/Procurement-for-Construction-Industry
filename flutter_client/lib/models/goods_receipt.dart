import 'package:flutter_client/models/product_model.dart';

enum GoodsReceiptStatus { pendingShipping, received }

class Supplier {
  final String id;
  final String name;
  final String email;
  final String contactNumber;

  Supplier({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      contactNumber: json['contactNumber'],
    );
  }
}

class Site {
  final String id;
  final String name;
  final String address;
  final String contactNumber;

  Site({
    required this.id,
    required this.name,
    required this.address,
    required this.contactNumber,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      contactNumber: json['contactNumber'],
    );
  }
}

class GoodsReceiptItem {
  final Product item;
  final int quantity;

  GoodsReceiptItem({
    required this.item,
    required this.quantity,
  });
}

class GoodsReceipt {
  final String id;
  final String siteManager;
  final String goodsReceiptId;
  final GoodsReceiptStatus status;
  final List<GoodsReceiptItem> items;
  final Supplier supplier;
  final DateTime createdAt;
  final Site site;

  GoodsReceipt({
    required this.id,
    required this.supplier,
    required this.site,
    required this.siteManager,
    required this.goodsReceiptId,
    required this.status,
    required this.items,
    required this.createdAt,
  });

  factory GoodsReceipt.fromJson(Map<String, dynamic> json) {
    return GoodsReceipt(
      id: json['_id'],
      supplier: Supplier.fromJson(json['supplier']),
      site: Site.fromJson(json['site']),
      siteManager: json['siteManager'],
      goodsReceiptId: json['goodReceiptId'],
      status: json['status'] == 'received'
          ? GoodsReceiptStatus.received
          : GoodsReceiptStatus.pendingShipping,
      items: json['items']
          .map<GoodsReceiptItem>(
            (item) => GoodsReceiptItem(
              item: Product.fromJson(item['item']),
              quantity: item['quantity'],
            ),
          )
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
