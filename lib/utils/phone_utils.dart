/// Converts a Ghanaian phone number into a synthetic email address.
String phoneToEmail(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  String local;
  if (digits.startsWith('233')) {
    local = digits.substring(3); // e.g. 233267897676 → 267897676
  } else if (digits.startsWith('0')) {
    local = digits.substring(1); // e.g. 0267897676 → 267897676
  } else {
    local = digits;
  }
  return '233$local@eco.com';
}

