class GrammarLevel {
  final String title;
  final String comprehensiveExplanation;
  final String importance;
  final List<Module> modules;

  GrammarLevel({
    required this.title,
    required this.comprehensiveExplanation,
    required this.importance,
    required this.modules,
  });

  // Convert GrammarLevel object to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'comprehensiveExplanation': comprehensiveExplanation,
      'importance': importance,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }

  // Factory constructor to create a GrammarLevel object from Firestore data
  factory GrammarLevel.fromJson(Map<String, dynamic> json) {
    return GrammarLevel(
      title: json['title'],
      comprehensiveExplanation: json['comprehensiveExplanation'],
      importance: json['importance'],
      modules: (json['modules'] as List)
          .map((moduleJson) => Module.fromJson(moduleJson))
          .toList(),
    );
  }

  // From map method to map Firestore data to model
  factory GrammarLevel.fromMap(Map<String, dynamic> map) {
    var modulesList = (map['modules'] as List)
        .map((module) => Module.fromMap(module))
        .toList();

    return GrammarLevel(
      title: map['title'] ?? '',
      comprehensiveExplanation: map['comprehensiveExplanation'] ?? '',
      importance: map['importance'] ?? '',
      modules: modulesList,
    );
  }
}

class Module {
  final String moduleTitle;
  final LessonContent lessonContent;

  Module({
    required this.moduleTitle,
    required this.lessonContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'moduleTitle': moduleTitle,
      'lessonContent': lessonContent.toJson(),
    };
  }

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      moduleTitle: json['moduleTitle'],
      lessonContent: LessonContent.fromJson(json['lessonContent']),
    );
  }

  // From map method to map module data to model
  factory Module.fromMap(Map<String, dynamic> map) {
    return Module(
      moduleTitle: map['moduleTitle'] ?? '',
      lessonContent: LessonContent.fromMap(map['lessonContent']),
    );
  }
}

class LessonContent {
  final String explanation;
  final List<Example> examples;

  LessonContent({
    required this.explanation,
    required this.examples,
  });

  Map<String, dynamic> toJson() {
    return {
      'explanation': explanation,
      'examples': examples.map((example) => example.toJson()).toList(),
    };
  }

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
      explanation: json['explanation'],
      examples: (json['examples'] as List)
          .map((exampleJson) => Example.fromJson(exampleJson))
          .toList(),
    );
  }

  // From map method to map lesson content data to model
  factory LessonContent.fromMap(Map<String, dynamic> map) {
    var exampleList = (map['examples'] as List)
        .map((example) => Example.fromMap(example))
        .toList();

    return LessonContent(
      explanation: map['explanation'] ?? '',
      examples: exampleList,
    );
  }
}

class Example {
  final String sentence;
  final String explanation;

  Example({
    required this.sentence,
    required this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'explanation': explanation,
    };
  }

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      sentence: json['sentence'],
      explanation: json['explanation'],
    );
  }

  // From map method to map example data to model
  factory Example.fromMap(Map<String, dynamic> map) {
    return Example(
      sentence: map['sentence'] ?? '',
      explanation: map['explanation'] ?? '',
    );
  }
}
