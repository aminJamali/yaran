import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_add_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_delete_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_get_dto.dart';
import 'package:moordak/data/models/transaction_model.dart';
import 'package:moordak/data/repositories/mourdak_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  MourdakRepository _mourdakRepository = new MourdakRepository();
  TransactionBloc() : super(null);

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is AddTransactionEvent) {
      yield TransactionLoadingState();
      final failedOrResult =
          await _mourdakRepository.transactionInsert(event.transactionAddDto);

      yield failedOrResult.fold(
          (exception) => TransactionExceptionState(exception.message),
          (isSuccessed) => AddTransactionState(isSuccessed));
    } else if (event is EditTransactionEvent) {
      yield TransactionLoadingState();
      final failedOrResult =
          await _mourdakRepository.transactionEdit(event.transactionAddDto);

      yield failedOrResult.fold(
          (exception) => TransactionExceptionState(exception.message),
          (isSuccessed) => EditTransactionState(isSuccessed));
    } else if (event is GetAllTransactionsEvent) {
      yield TransactionLoadingState();
      final failedOrResult =
          await _mourdakRepository.getAllTransactions(event.transactionGetDto);

      yield failedOrResult.fold(
          (exception) => TransactionExceptionState(exception.message),
          (transactions) => GetAllTransactionsState(transactions));
    } else if (event is GetAllTransactionsBySearchEvent) {
      yield TransactionLoadingState();
      final failedOrResult = await _mourdakRepository
          .getAllTransactionsBySearch(event.transactionGetDto);

      yield failedOrResult.fold(
          (exception) => TransactionExceptionState(exception.message),
          (transactions) => GetAllTransactionsState(transactions));
    } else if (event is DeleteTransactionEvent) {
      yield TransactionLoadingState();
      final failedOrResult = await _mourdakRepository
          .transactionDelete(event.transactionDeleteDto);

      yield failedOrResult.fold(
          (exception) => TransactionExceptionState(exception.message),
          (isSuccessed) => DeleteTransactionState(isSuccessed));
    } else if (event is EditTransactionEvent) {
      yield TransactionLoadingState();
      final failedOrResult =
          await _mourdakRepository.transactionEdit(event.transactionAddDto);

      yield failedOrResult.fold(
          (exception) => TransactionExceptionState(exception.message),
          (isSuccessed) => DeleteTransactionState(isSuccessed));
    }
  }
}
