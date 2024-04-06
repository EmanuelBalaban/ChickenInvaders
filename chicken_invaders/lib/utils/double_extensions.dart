import 'dart:math';

extension FractionalPrecision on double {
  double withPrecision(int digits) {
    final tenToPower = pow(10, digits);

    return (this * tenToPower).truncateToDouble() / tenToPower;
  }
}
