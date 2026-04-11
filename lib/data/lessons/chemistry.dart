import '../../models/lesson.dart';
import '../../models/quiz_problem.dart';

final atomicStructureLesson = Lesson(
  title: "Atomic Structure",
  description: "Learn about protons, neutrons, electrons, and atomic number.",
  sections: [
    LessonSection(
      content: """
      Atoms are made of protons (+), neutrons (neutral), and electrons (-).
      Atomic number = number of protons
      Mass number = protons + neutrons
      Electrons occupy energy levels.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "An atom has \$6\$ protons and \$6\$ neutrons. Its atomic number is?",
      type: QuestionType.typing,
      answer: "\$6\$",
      hint: "Atomic number equals the number of protons.",
    ),
    QuizProblem(
      question: "True or False: Electrons have positive charge.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint: "Electrons are negatively charged particles.",
    ),
  ],
);

final chemicalBondingLesson = Lesson(
  title: "Chemical Bonding",
  description: "Learn about ionic, covalent, and metallic bonds.",
  sections: [
    LessonSection(
      content: """
      Ionic bond: transfer of electrons (metal + nonmetal)
      Covalent bond: sharing of electrons (nonmetal + nonmetal)
      Metallic bond: electrons delocalized in a metal lattice
      """,
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.toggleChoiceExperiment,
          title: "Bond Predictor",
          prompt:
              "Enable the Na + Cl scenario, then choose the likely bond type.",
          toggleLabel: "Activate metal + nonmetal case (Na + Cl)",
          options: ["Ionic", "Covalent", "Metallic"],
          correctOption: "Ionic",
          revealOnComplete:
              "Correct. Na and Cl form an ionic bond through electron transfer.",
        ),
      ],
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "True or False: Covalent bonds share electrons.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "Covalent bonding is based on sharing electron pairs.",
    ),
    QuizProblem(
      question:
          "Which bond forms between \$\\mathrm{Na}\$ and \$\\mathrm{Cl}\$?",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\text{Ionic}\$",
        "\$\\text{Covalent}\$",
        "\$\\text{Metallic}\$",
        "\$\\text{Hydrogen}\$",
      ],
      answer: "\$\\text{Ionic}\$",
      hint: "A metal and a nonmetal usually form this bond type.",
    ),
  ],
);

final chemistryLessons = [atomicStructureLesson, chemicalBondingLesson];
