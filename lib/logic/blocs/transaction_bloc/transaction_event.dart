part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final TransactionAddDto transactionAddDto;

  AddTransactionEvent(this.transactionAddDto);
}

class EditTransactionEvent extends TransactionEvent {
  final TransactionAddDto transactionAddDto;

  EditTransactionEvent(this.transactionAddDto);
}

class GetAllTransactionsEvent extends TransactionEvent {
  final TransactionGetDto transactionGetDto;

  GetAllTransactionsEvent(this.transactionGetDto);
}

class GetAllTransactionsBySearchEvent extends TransactionEvent {
  final TransactionGetDto transactionGetDto;

  GetAllTransactionsBySearchEvent(this.transactionGetDto);
}

class GetTransacrionByIdEvent extends TransactionEvent {
  final int id;

  GetTransacrionByIdEvent(this.id);
}

class DeleteTransactionEvent extends TransactionEvent {
  final TransactionDeleteDto transactionDeleteDto;

  DeleteTransactionEvent(this.transactionDeleteDto);
}
