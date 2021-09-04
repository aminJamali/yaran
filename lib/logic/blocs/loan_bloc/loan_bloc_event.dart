part of 'loan_bloc.dart';

@immutable
abstract class LoanBlocEvent {}

class AddLoanEvent extends LoanBlocEvent {
  final AddLoanDto addLoanDto;

  AddLoanEvent(this.addLoanDto);
}

class EditLoanEvent extends LoanBlocEvent {
  final AddLoanDto addLoanDto;

  EditLoanEvent(this.addLoanDto);
}

class GetAllLoansEvent extends LoanBlocEvent {
  final GetLoanDto getLoanDto;

  GetAllLoansEvent(this.getLoanDto);
}

class GetAllLoansBySearchEvent extends LoanBlocEvent {
  final GetLoanDto getLoanDto;

  GetAllLoansBySearchEvent(this.getLoanDto);
}

class DeleteLoanEvent extends LoanBlocEvent {
  final DeleteLoanDto deleteLoanDto;

  DeleteLoanEvent(this.deleteLoanDto);
}
