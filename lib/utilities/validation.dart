String? validateRequired(String? currentValue, {String fieldType = " value"}) {
  if (currentValue?.isEmpty == true) {
    return "Please enter a$fieldType";
  }

  return null;
}