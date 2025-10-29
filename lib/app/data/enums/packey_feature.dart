enum AppFeature {
  caissier('G_CAISSIER'),
  produit('G_PRODUIT'),
  personnalisation('G_PERSONNALISATION'),
  historiqueVente('V_HIST_VENTE'),
  vente('G_VENTE'),
  facture('G_FACTURE'),
  session('G_SESSION'),
  print('ACCESS_PRINTER');

  final String code;
  const AppFeature(this.code);
}
