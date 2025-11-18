// constants.dart


// constants.dart — versión sin Firebase

Future<void> saveInteraction(String button) async {
  // No Firebase → solo registro local
  print("Interacción: $button");
}

// remover acentos
extension StringNormalizer on String {
  String normalize() {
    const withAccents =
        'áàäâãéèëêíìïîóòöôõúùüûñÁÀÄÂÃÉÈËÊÍÌÏÎÓÒÖÔÕÚÙÜÛÑçÇ';
    const withoutAccents =
        'aaaaaeeeeiiiiooooouuuunAAAAAEEEEIIIIOOOOOUUUNcC';

    String str = this;
    for (int i = 0; i < withAccents.length; i++) {
      str = str.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return str;
  }
}


/* // remover acentos
extension StringNormalizer on String {
  String normalize() {
    const withAccents =
        'áàäâãéèëêíìïîóòöôõúùüûñÁÀÄÂÃÉÈËÊÍÌÏÎÓÒÖÔÕÚÙÜÛÑçÇ';
    const withoutAccents =
        'aaaaaeeeeiiiiooooouuuunAAAAAEEEEIIIIOOOOOUUUNcC';

    String str = this;
    for (int i = 0; i < withAccents.length; i++) {
      str = str.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return str;
  }
}
 */