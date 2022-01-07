class ListItem {
  String? amount;
  bool? checked;
  String? name;

  ListItem({this.amount, this.checked, this.name});


  Map<String, Object?> toJson() {
    return {"amount": amount, "checked": checked, "name": name};
  }
}