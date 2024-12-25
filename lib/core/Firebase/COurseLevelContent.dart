import 'package:grammar_checker_app_updated/core/model/CourseModel.dart';

var level7 = GrammarLevel(
  title: "Advanced Grammar and Usage",
  comprehensiveExplanation:
      "Level 7 focuses on the most complex and advanced grammar structures in English, including conditionals, reported speech, the subjunctive mood, and complex passive constructions. These topics will refine your ability to express hypothetical situations, indirect speech, and formal or nuanced statements. Mastering these structures will allow you to communicate with precision and sophistication in both written and spoken English.",
  importance:
      "Mastering advanced grammar and usage is essential for achieving fluency and sophistication in English. The ability to use conditionals, reported speech, and the subjunctive mood will enable you to express complex ideas, reflect on hypothetical situations, and communicate in formal or indirect ways. Understanding complex passive constructions further enhances your writing's clarity and depth, especially in formal contexts.",
  modules: [
    Module(
      moduleTitle: "Conditionals (Type 1, 2, and 3)",
      lessonContent: LessonContent(
        explanation:
            "Conditionals express situations that may or may not happen depending on other factors. There are three types of conditionals: Type 1 (real, present/future), Type 2 (unreal, present), and Type 3 (unreal, past). Each conditional type is used to express different degrees of possibility, necessity, or hypothetical situations.",
        examples: [
          Example(
            sentence: "If it rains tomorrow, we will stay indoors.",
            explanation:
                "Type 1 Conditional (real, future): This structure describes a real situation in the future. The action ('we will stay indoors') depends on a condition ('if it rains').",
          ),
          Example(
            sentence: "If I were you, I would study more for the exam.",
            explanation:
                "Type 2 Conditional (unreal, present): This expresses a hypothetical situation in the present or future. The action ('would study') is based on a condition that is unlikely or imagined ('If I were you').",
          ),
          Example(
            sentence:
                "If they had known about the meeting, they would have attended.",
            explanation:
                "Type 3 Conditional (unreal, past): This is used to express a hypothetical past situation and its possible past outcome. The action ('would have attended') is based on a past condition that did not occur ('If they had known').",
          )
        ],
      ),
    ),
    Module(
      moduleTitle: "Reported Speech",
      lessonContent: LessonContent(
        explanation:
            "Reported speech (also known as indirect speech) is used to report what someone else has said without quoting their exact words. This requires changes to pronouns, verb tenses, and sometimes word order. Reported speech is common in formal and informal contexts and is important for accurate paraphrasing.",
        examples: [
          Example(
            sentence: "She said, 'I am going to the market.'",
            explanation:
                "Direct speech: The speaker's exact words are quoted. In reported speech, this becomes: 'She said that she was going to the market.' The verb tense changes from present ('am') to past ('was').",
          ),
          Example(
            sentence: "He asked, 'Do you want to join me for dinner?'",
            explanation:
                "In reported speech, this becomes: 'He asked if I wanted to join him for dinner.' The direct question is turned into a statement, and the verb tense changes accordingly.",
          ),
          Example(
            sentence: "John said, 'I have finished the report.'",
            explanation:
                "In reported speech: 'John said that he had finished the report.' The verb tense changes from present perfect ('have finished') to past perfect ('had finished').",
          )
        ],
      ),
    ),
    Module(
      moduleTitle: "The Subjunctive Mood",
      lessonContent: LessonContent(
        explanation:
            "The subjunctive mood is used to express wishes, hypothetical situations, necessity, or demands. It is typically used in dependent clauses and differs from the indicative mood, which expresses factual statements. The subjunctive is common in formal and academic writing.",
        examples: [
          Example(
            sentence: "I wish she were here with us.",
            explanation:
                "The subjunctive verb form ('were') is used here instead of 'was' to express a wish or hypothetical situation. This is a key feature of the subjunctive mood.",
          ),
          Example(
            sentence: "It is essential that he be on time.",
            explanation:
                "The verb 'be' is used in the subjunctive mood to express necessity. In the indicative mood, it would be 'is.'",
          ),
          Example(
            sentence: "If I were rich, I would travel the world.",
            explanation:
                "The subjunctive mood is used to express an unreal or hypothetical situation. 'Were' is used instead of 'was' in this context to indicate a hypothetical condition.",
          )
        ],
      ),
    ),
    Module(
      moduleTitle: "Complex Passive Constructions",
      lessonContent: LessonContent(
        explanation:
            "Complex passive constructions occur when the focus is on the action and its recipient, and these constructions may involve more than one auxiliary verb. Passive voice can be used in various tenses, including perfect and continuous, and may also include modal verbs. These structures are common in formal or academic writing.",
        examples: [
          Example(
            sentence: "The book has been read by many people.",
            explanation:
                "This is a complex passive construction with the present perfect tense. 'Has been read' shifts the focus from the doer to the action and the recipient (the book).",
          ),
          Example(
            sentence: "The report will have been completed by next week.",
            explanation:
                "In this example, the passive construction 'will have been completed' expresses an action that will be finished at a future time, with emphasis on the result rather than the doer.",
          ),
          Example(
            sentence: "The project is being completed by the team.",
            explanation:
                "This passive construction uses the present continuous tense ('is being completed') to describe an ongoing action with an emphasis on the process rather than the doer.",
          )
        ],
      ),
    ),
    Module(
      moduleTitle: "Advanced Modals (Past, Future, and Hypotheticals)",
      lessonContent: LessonContent(
        explanation:
            "Advanced modal verbs extend the basic function of modals to express hypothetical situations in the past or future, as well as to offer advice, express certainty, or make polite requests. Modal verbs like 'might have,' 'could have,' and 'should have' are used to discuss past possibilities or regrets.",
        examples: [
          Example(
            sentence: "He might have missed the bus if he had left later.",
            explanation:
                "This construction uses the modal 'might have' to discuss a past possibility that did not happen. It refers to a hypothetical past situation and its result.",
          ),
          Example(
            sentence: "You should have studied harder for the test.",
            explanation:
                "The modal 'should have' is used to express regret or a past action that was expected but not done.",
          ),
          Example(
            sentence: "By the time you arrive, I could have finished the task.",
            explanation:
                "The modal 'could have' expresses a future possibility that depends on the condition of your arrival.",
          )
        ],
      ),
    )
  ],
);
