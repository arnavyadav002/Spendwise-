class Money {
  final int paise;

  const Money(this.paise);

  double get asRupees => paise / 100;

  String get formatted => 'Rs. ${asRupees.toStringAsFixed(2)}';

  Money operator +(Money other) => Money(paise + other.paise);
  Money operator -(Money other) => Money(paise - other.paise);

  @override
  String toString() => formatted;
}
