part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class AddTransactionState extends TransactionState {
  final bool isSuccessed;

  AddTransactionState(this.isSuccessed);
}

class EditTransactionState extends TransactionState {
  final bool isSuccessed;

  EditTransactionState(this.isSuccessed);
}

class GetAllTransactionsState extends TransactionState {
  final List<TransactionModel> transactions;

  GetAllTransactionsState(this.transactions);
}

class GetAllTransactionsBySearchState extends TransactionState {
  final List<TransactionModel> transactions;

  GetAllTransactionsBySearchState(this.transactions);
}

class GetTransacrionByIdState extends TransactionState {
  final TransactionModel transactionModel;

  GetTransacrionByIdState(this.transactionModel);
}

class DeleteTransactionState extends TransactionState {
  final bool isSuccessed;

  DeleteTransactionState(this.isSuccessed);
}

class TransactionLoadingState extends TransactionState {}

class TransactionExceptionState extends TransactionState {
  final String text;

  TransactionExceptionState(this.text);
}
