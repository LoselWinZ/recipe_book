class RecipeIngredient {
   String? amount;
   String? einheit;
   String? id;
   String? ingredientId;
   String? name;

  RecipeIngredient({this.amount, this.einheit, this.id, this.ingredientId, this.name});

   Map<String, Object?> toJson() {
      return {"id": id, "einheit": einheit, "name": name, "ingredientId": ingredientId, "amount": amount};
   }
}
