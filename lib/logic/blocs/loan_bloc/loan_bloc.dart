import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moordak/data/dtos/loan_dtos/add_loan_dto.dart';
import 'package:moordak/data/dtos/loan_dtos/delete_loan_dto.dart';
import 'package:moordak/data/dtos/loan_dtos/get_loan_dto.dart';
import 'package:moordak/data/models/loan_model.dart';
import 'package:moordak/data/repositories/mourdak_repository.dart';

part 'loan_bloc_event.dart';
part 'loan_bloc_state.dart';

class LoanBloc extends Bloc<LoanBlocEvent, LoanBlocState> {
  LoanBloc() : super(null);
  MourdakRepository _mourdakRepository = new MourdakRepository();
  @override
  Stream<LoanBlocState> mapEventToState(
    LoanBlocEvent event,
  ) async* {
    if (event is AddLoanEvent) {
      yield LoanLoadingState();
      final failedOrResult =
          await _mourdakRepository.loanInsert(event.addLoanDto);

      yield failedOrResult.fold(
          (exception) => LoanExceptionState(exception.message),
          (isSuccessed) => AddLoanState(isSuccessed));
    } else if (event is EditLoanEvent) {
      yield LoanLoadingState();
      final failedOrResult =
          await _mourdakRepository.loanEdit(event.addLoanDto);

      yield failedOrResult.fold(
          (exception) => LoanExceptionState(exception.message),
          (isSuccessed) => AddLoanState(isSuccessed));
    } else if (event is GetAllLoansEvent) {
      yield LoanLoadingState();
      final failedOrResult =
          await _mourdakRepository.getAllLoans(event.getLoanDto);

      yield failedOrResult.fold(
          (exception) => LoanExceptionState(exception.message),
          (loans) => GetAllLoansState(loans));
    } else if (event is GetAllLoansBySearchEvent) {
      yield LoanLoadingState();
      final failedOrResult =
          await _mourdakRepository.getAllLoansBySearch(event.getLoanDto);

      yield failedOrResult.fold(
          (exception) => LoanExceptionState(exception.message),
          (loans) => GetAllLoansBySearchState(loans));
    } else if (event is DeleteLoanEvent) {
      final failedOrResult =
          await _mourdakRepository.loanDelete(event.deleteLoanDto);

      yield failedOrResult.fold(
          (exception) => LoanExceptionState(exception.message),
          (isSuccessed) => DeleteLoanState(isSuccessed));
    }
  }
}
