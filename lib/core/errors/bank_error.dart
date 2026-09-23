import 'package:equatable/equatable.dart';

sealed class BankError extends Equatable {
  final String message;

  const BankError(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkError extends BankError {
  const NetworkError(super.message);
}

class UnauthorizedError extends BankError {
  const UnauthorizedError([super.message = 'Unauthorized']);
}

class UnknownBankError extends BankError {
  const UnknownBankError(super.message);
}
