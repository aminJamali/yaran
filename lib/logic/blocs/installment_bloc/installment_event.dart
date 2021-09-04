part of 'installment_bloc.dart';

@immutable
abstract class InstallmentEvent {}

class DoInstallmentEvent extends InstallmentEvent {
  final DoInstallmentDto doInstallment;

  DoInstallmentEvent(this.doInstallment);
}

class PaidInstallmentEvent extends InstallmentEvent {
  final PaidInstallmentDto paidInstallment;

  PaidInstallmentEvent(this.paidInstallment);
}
