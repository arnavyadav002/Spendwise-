import 'package:equatable/equatable.dart';

class ExpenseCategory extends Equatable {
  final String id;
  final String name;
  final String icon;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'icon': icon};

  @override
  List<Object?> get props => [id, name, icon];
}
