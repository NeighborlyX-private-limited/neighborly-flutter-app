import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/payment/domain/usecases/create_order_usecase.dart';
import 'package:neighborly_flutter_app/features/payment/domain/usecases/verify_payment_usecase.dart';

abstract class PaymentEvent {}

class CreateOrderEvent extends PaymentEvent {
  final Map<String, dynamic> params;
  CreateOrderEvent(this.params);
}

class VerifyPaymentEvent extends PaymentEvent {
  final Map<String, dynamic> params;
  VerifyPaymentEvent(this.params);
}

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentCreated extends PaymentState {
  final Map<String, dynamic> orderData;
  PaymentCreated(this.orderData);
}

class PaymentVerified extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreateOrderUseCase createOrderUseCase;
  final VerifyPaymentUseCase verifyPaymentUseCase;

  PaymentBloc(
      {required this.createOrderUseCase, required this.verifyPaymentUseCase})
      : super(PaymentInitial()) {
    on<CreateOrderEvent>((event, emit) async {
      emit(PaymentLoading());
      try {
        final orderData = await createOrderUseCase(event.params);
        emit(PaymentCreated(orderData));
      } catch (e) {
        emit(PaymentError(e.toString()));
      }
    });

    on<VerifyPaymentEvent>((event, emit) async {
      emit(PaymentLoading());
      try {
        final isVerified = await verifyPaymentUseCase(event.params);
        if (isVerified) {
          emit(PaymentVerified());
        } else {
          emit(PaymentError("Verification Failed"));
        }
      } catch (e) {
        emit(PaymentError(e.toString()));
      }
    });
  }
}
