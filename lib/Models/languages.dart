class Language{
  final int id;
  final String name;
  final String langCode;

  Language({required this.id, required this.name, required this.langCode});

  static List<Language> languagesList(){
    return <Language>[
      Language(id: 1, name: 'English', langCode: 'en'),
      Language(id: 2, name: 'Spanish', langCode: 'es')
    ];
  }
}