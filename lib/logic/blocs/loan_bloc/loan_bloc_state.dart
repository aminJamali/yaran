part of 'loan_bloc.dart';

@immutable
abstract class LoanBlocState {}

class LoanBlocInitial extends LoanBlocState {}

class AddLoanState extends LoanBlocState {
  final bool isSuccessed;

  AddLoanState(this.isSuccessed);
}

class EditLoanState extends LoanBlocState {
  final bool isSuccessed;

  EditLoanState(this.isSuccessed);
}

class LoanLoadingState extends LoanBlocState {}

class LoanExceptionState extends LoanBlocState {
  final String message;

  LoanExceptionState(this.message);
}

class GetAllLoansState extends LoanBlocState {
  final List<LoanModel> loans;

  GetAllLoansState(this.loans);
}

class GetAllLoansBySearchState extends LoanBlocState {
  final List<LoanModel> loans;

  GetAllLoansBySearchState(this.loans);
}

class DeleteLoanState extends LoanBlocState {
  final bool isSuccessed;

  DeleteLoanState(this.isSuccessed);
}
