import 'package:equatable/equatable.dart';

class Money extends Equatable {
  final int paise;

  const Money(this.paise);

  double get asRupees => paise / 100;

  String get formatted => 'Rs. ${asRupees.toStringAsFixed(2)}';

  Money operator +(Money other) => Money(paise + other.paise);
  Money operator -(Money other) => Money(paise - other.paise);

  @override
  List<Object?> get props => [paise];

  @override
  String toString() => formatted;
}
