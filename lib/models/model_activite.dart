class Activite {
  final String imageUrl;
  final String lieu;
  final String categorie;
  final double prix;
  final int nbr_min;
  final String titre;

  Activite({
    required this.imageUrl,
    required this.lieu,
    required this.categorie,
    required this.prix,
    required this.nbr_min,
    required this.titre,
  });

  factory Activite.fromJson(Map<String, dynamic> json) {
    return Activite(
      imageUrl: json['imageUrl'] ?? '',
      lieu: json['adresse'] ?? '',
      categorie: json['categorie'] ?? '',
      prix: (json['prix'] ?? 0).toDouble(),
      nbr_min: json['nbr_min'] ?? 0,
      titre: json['titre'] ?? '',
    );
  }
}
