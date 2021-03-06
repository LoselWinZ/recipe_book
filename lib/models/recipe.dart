import 'dart:collection';

class Recipe {
   String? id;
   String? author;
   String? userId;
   String? name;
   String? imgLink;
   int? portions;
   String? preparation;
   String? description;
   String? cooktime;
   LinkedHashMap? searchableIndex;
   String? categorie;

  Recipe({this.id, this.author, this.userId, this.name, this.imgLink, this.portions, this.preparation, this.description, this.cooktime, this.categorie, this.searchableIndex});

   Map<String, Object?> toJson() {
      return {"id": id, "author": author, "name": name, "imgLink": imgLink, "userId": userId, "portions": portions, "preparation": preparation, "description": description, "cooktime": cooktime, "categorie": categorie, "searchableIndex": searchableIndex};
   }
}
