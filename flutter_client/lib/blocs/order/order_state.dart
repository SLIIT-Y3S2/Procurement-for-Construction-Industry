part of 'order_bloc.dart';

class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class CreatingOrder extends OrderInitial {}

class OrderCreated extends OrderInitial {
  const OrderCreated();
}

class OrderNotCreated extends OrderInitial {
  final String message;

  const OrderNotCreated({required this.message});
}

class GettingOrders extends OrderInitial {}

class OrdersRetrieved extends OrderInitial {
  final List<Order> orders;

  const OrdersRetrieved({required this.orders});
}

class ErrorRetrievingOrders extends OrderInitial {
  final String message;

  const ErrorRetrievingOrders({required this.message});
}
