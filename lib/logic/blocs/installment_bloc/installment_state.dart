part of 'installment_bloc.dart';

@immutable
abstract class InstallmentState {}

class InstallmentInitial extends InstallmentState {}

class DoInstallmentState extends InstallmentState {
  final bool isSuccessed;

  DoInstallmentState(this.isSuccessed);
}

class PaidInstallmentState extends InstallmentState {
  final bool isSuccessed;

  PaidInstallmentState(this.isSuccessed);
}

class InstallmentLoadingState extends InstallmentState {}

class InstallmentExceptionState extends InstallmentState {
  final String message;

  InstallmentExceptionState(this.message);
}
