class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final number = double.tryParse(value);
    if (number == null || number <= 0) return 'Enter a valid amount';
    return null;
  }
}
