class PaidInstallmentDto {
  final int installmentId;
  final String payDate, apiToken;
  final List<dynamic> imageArray;

  PaidInstallmentDto(
      {this.installmentId, this.payDate, this.apiToken, this.imageArray});
}
