class ResultProcessing {
 static Map<String, String> lesionNames = {
  'nv': 'Melanocytic nevi',
  'mel': 'Melanoma',
  'bkl': 'Benign keratosis ',
  'bcc': 'Basal cell carcinoma',
  'akiec': 'Actinic keratoses',
  'vasc': 'Vascular lesions',
  'df': 'Dermatofibroma'
  };

  static Map<String, bool> lesionBenign = {
    'nv': true,
    'mel': false,
    'bkl': true,
    'bcc': false,
    'akiec': true,
    'vasc': true,
    'df': true,
  };

  static bool getBenign(String lesionType) {
    return lesionBenign[lesionType]!;
  }

  static String getLesionName(String lesionType) {
    return lesionNames[lesionType]!;
  }
}