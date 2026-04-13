import '../../models/lesson.dart';
import '../../models/quiz_problem.dart';

final introChemistryLesson = Lesson(
  title: "Introduction to Chemistry",
  description:
      "Discover what chemistry is and why it matters in everyday life.",
  sections: [
    LessonSection(
      content: """
Chemistry is the branch of science that studies matter — its composition, properties, structure, and the changes it undergoes.
 
Everything around you is chemistry:
- The food you eat (digestion is a chemical process)
- The air you breathe (oxygen reacting in your cells)
- The materials in your phone (metals, plastics, semiconductors)
      """,
      message: "Chemistry is not just in the lab — it's everywhere!",
      additionalContent:
          "Chemistry connects to biology, physics, medicine, engineering, and environmental science.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Branches of Chemistry",
          prompt:
              "Drag these chemistry branches into order from most fundamental to most applied.",
          draggableOptions: [
            "Analytical Chemistry",
            "Physical Chemistry",
            "Industrial Chemistry",
            "Organic Chemistry",
          ],
          expectedOrder: [
            "Physical Chemistry",
            "Organic Chemistry",
            "Analytical Chemistry",
            "Industrial Chemistry",
          ],
          revealOnComplete:
              "Good. Chemistry spans from fundamental theory to large-scale industrial application.",
        ),
      ],
    ),
    LessonSection(
      content: """
Matter is anything that has mass and takes up space. It exists in different states:
 
- Solid: definite shape and volume (e.g., ice)
- Liquid: definite volume, no definite shape (e.g., water)
- Gas: no definite shape or volume (e.g., steam)
- Plasma: ionized gas at extremely high energy (e.g., the sun)
      """,
      additionalContent:
          "Matter can change state when energy is added or removed.",
    ),
    LessonSection(
      content: """
Physical vs. Chemical Changes:
 
Physical change: alters appearance but not chemical identity.
Examples: cutting paper, melting ice, dissolving sugar.
 
Chemical change: produces new substances with different properties.
Examples: burning wood, rusting iron, baking a cake.
 
Signs of a chemical change: color change, gas produced, precipitate formed, energy released or absorbed.
      """,
      message:
          "If a new substance is formed, it's chemical. If not, it's physical!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "True or False: Melting ice is a chemical change.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "Melting changes state but not chemical identity — it is a physical change.",
    ),
    QuizProblem(
      question: "Which of the following is a chemical change?",
      type: QuestionType.multipleChoice,
      options: [
        "Dissolving salt in water",
        "Cutting a piece of paper",
        "Rusting of iron",
        "Melting of wax",
      ],
      answer: "Rusting of iron",
      hint:
          "Rusting produces a new substance (iron oxide) — that's a chemical change.",
    ),
    QuizProblem(
      question: "What are the three common states of matter?",
      type: QuestionType.typing,
      answer: "solid, liquid, gas",

      hint:
          "Think of water as ice, liquid water, and steam. (Make sure the order of your answer aligns with how the 'hint' is given.)",
    ),
  ],
);

final unitsMeasurementLesson = Lesson(
  title: "Units and Measurement",
  description: "Learn SI units, significant figures, and scientific notation.",
  sections: [
    LessonSection(
      content: """
The International System of Units (SI) provides a standard for scientific measurement.
 
Base SI units used in chemistry:
- Mass: kilogram (kg)
- Length: meter (m)
- Time: second (s)
- Temperature: Kelvin (K)
- Amount of substance: mole (mol)
- Electric current: ampere (A)
      """,
      message:
          "SI units make science universal — everyone uses the same language!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Match Units to Quantities",
          prompt:
              "Drag these SI units to match their measured quantities in order.",
          draggableOptions: [
            "Temperature → Kelvin (K)",
            "Amount → mole (mol)",
            "Mass → kilogram (kg)",
          ],
          expectedOrder: [
            "Mass → kilogram (kg)",
            "Temperature → Kelvin (K)",
            "Amount → mole (mol)",
          ],
          revealOnComplete:
              "Well done! These three SI units are especially important in chemistry.",
        ),
      ],
    ),
    LessonSection(
      content: """
Significant figures (sig figs) represent the precision of a measurement.
 
Rules:
1. All non-zero digits are significant.
2. Zeros between non-zero digits are significant.
3. Leading zeros are NOT significant.
4. Trailing zeros after a decimal point ARE significant.
 
Examples:
- 3.04 → 3 sig figs
- 0.0052 → 2 sig figs
- 4.500 → 4 sig figs
      """,
      additionalContent:
          "When multiplying or dividing, keep the fewest sig figs. When adding or subtracting, keep the fewest decimal places.",
    ),
    LessonSection(
      content: """
Scientific notation expresses very large or very small numbers as:
 
\$N \\times 10^n\$
 
where \$1 \\leq N < 10\$ and \$n\$ is an integer.
 
Examples:
- \$602{,}000{,}000{,}000{,}000{,}000{,}000{,}000 = 6.02 \\times 10^{23}\$ (Avogadro's number)
- \$0.000000001\\ \\mathrm{m} = 1 \\times 10^{-9}\\ \\mathrm{m}\$ (1 nanometer)
      """,
      message:
          "Scientific notation keeps very big and very small numbers manageable!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Powers of Ten",
          prompt:
              "Increase the exponent and observe how the value scales dramatically.",
          valueLabel: "Exponent n",
          valueUnit: "",
          minValue: 1,
          maxValue: 10,
          initialValue: 1,
          targetMin: 6,
          targetMax: 10,
          outputLabel: "Relative magnitude (×10^n)",
          outputMultiplier: 1,
          revealOnComplete:
              "Notice how each step multiplies the value by 10 — that's the power of scientific notation!",
        ),
      ],
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "How many significant figures does \$0.00420\$ have?",
      type: QuestionType.typing,
      answer: "\$3\$",
      hint:
          "Leading zeros are not significant. The trailing zero after 2 is significant.",
    ),
    QuizProblem(
      question:
          "True or False: The SI unit of temperature in chemistry is degrees Celsius.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "The SI unit is Kelvin (K), though Celsius is commonly used in the lab.",
    ),
    QuizProblem(
      question:
          "Which correctly expresses \$0.000056\$ in scientific notation?",
      type: QuestionType.multipleChoice,
      options: [
        "\$56 \\times 10^{-6}\$",
        "\$5.6 \\times 10^{-5}\$",
        "\$5.6 \\times 10^{5}\$",
        "\$0.56 \\times 10^{-4}\$",
      ],
      answer: "\$5.6 \\times 10^{-5}\$",
      hint:
          "Move the decimal until you have a number between 1 and 10, then count the moves.",
    ),
  ],
);

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

final inorganicNamingLesson = Lesson(
  title: "Naming and Writing Inorganic Compounds",
  description:
      "Learn the rules for naming ionic and covalent inorganic compounds.",
  sections: [
    LessonSection(
      content: """
Naming ionic compounds (metal + nonmetal):
 
1. Name the cation (metal) first — use its element name.
   - If the metal has variable charge, indicate it in Roman numerals: Fe²⁺ = Iron(II)
2. Name the anion (nonmetal) second — change the ending to -ide.
   - Cl⁻ = chloride, O²⁻ = oxide, S²⁻ = sulfide
 
Examples:
- NaCl = Sodium chloride
- FeCl₃ = Iron(III) chloride
- MgO = Magnesium oxide
      """,
      message: "Cation name first, anion name second with -ide ending!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Build a Compound Name",
          prompt: "Drag the parts into order to name FeCl₂ correctly.",
          draggableOptions: ["chloride", "Iron", "(II)"],
          expectedOrder: ["Iron", "(II)", "chloride"],
          revealOnComplete:
              "Correct! FeCl₂ is Iron(II) chloride — metal first, Roman numeral for charge, then anion with -ide.",
        ),
      ],
    ),
    LessonSection(
      content: """
Naming covalent compounds (nonmetal + nonmetal):
 
Use Greek prefixes to indicate the number of each atom:
1 = mono, 2 = di, 3 = tri, 4 = tetra, 5 = penta, 6 = hexa
 
Rules:
- First element: use prefix only if more than one atom (skip mono for first).
- Second element: always use a prefix, change ending to -ide.
 
Examples:
- CO = Carbon monoxide
- CO₂ = Carbon dioxide
- N₂O₄ = Dinitrogen tetroxide
- PCl₅ = Phosphorus pentachloride
      """,
      additionalContent:
          "The 'a' or 'o' is dropped before a vowel: tetr-oxide not tetra-oxide.",
    ),
    LessonSection(
      content: """
Common polyatomic ions to memorize:
 
- SO₄²⁻ = Sulfate
- NO₃⁻ = Nitrate
- OH⁻ = Hydroxide
- NH₄⁺ = Ammonium
- CO₃²⁻ = Carbonate
- PO₄³⁻ = Phosphate
 
When polyatomic ions appear in formulas, use parentheses for multiples:
Ca(NO₃)₂ = Calcium nitrate
      """,
      message:
          "Polyatomic ions act as a single unit — keep them together in formulas!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "What is the correct name for \$\\mathrm{CaCl_2}\$?",
      type: QuestionType.multipleChoice,
      options: [
        "Calcium dichloride",
        "Calcium chloride",
        "Calcium(II) chloride",
        "Dicalcium chloride",
      ],
      answer: "Calcium chloride",
      hint:
          "Calcium only has one common charge (+2), so no Roman numeral is needed.",
    ),
    QuizProblem(
      question: "True or False: CO₂ is named Carbon dioxide.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint:
          "C = carbon (no prefix since it's first and there's only 1), O₂ = dioxide.",
    ),
    QuizProblem(
      question: "What is the formula for Iron(III) oxide?",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\mathrm{Fe_2O_3}\$",
        "\$\\mathrm{FeO}\$",
        "\$\\mathrm{Fe_3O_2}\$",
        "\$\\mathrm{Fe_2O}\$",
      ],
      answer: "\$\\mathrm{Fe_2O_3}\$",
      hint: "Fe³⁺ and O²⁻. Use the criss-cross method: 2 Fe and 3 O.",
    ),
  ],
);

final chemicalReactionsLesson = Lesson(
  title: "Chemical Reactions",
  description: "Identify types of chemical reactions and balance equations.",
  sections: [
    LessonSection(
      content: """
A chemical reaction converts reactants into products. It is represented by a chemical equation:
 
Reactants → Products
 
The Law of Conservation of Mass requires that atoms are neither created nor destroyed — equations must be balanced (same number of each atom on both sides).
 
Example — unbalanced:
H₂ + O₂ → H₂O
 
Balanced:
2H₂ + O₂ → 2H₂O
      """,
      message: "Balance atoms on both sides — what goes in must come out!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Order the Balancing Steps",
          prompt:
              "Drag these steps into the correct order for balancing a chemical equation.",
          draggableOptions: [
            "Adjust coefficients to balance each element",
            "Count atoms of each element on both sides",
            "Write the unbalanced equation",
            "Verify all atoms are equal on both sides",
          ],
          expectedOrder: [
            "Write the unbalanced equation",
            "Count atoms of each element on both sides",
            "Adjust coefficients to balance each element",
            "Verify all atoms are equal on both sides",
          ],
          revealOnComplete:
              "Well done! Follow these steps methodically to balance any equation.",
        ),
      ],
    ),
    LessonSection(
      content: """
Five main types of chemical reactions:
 
1. Synthesis: A + B → AB (two substances combine)
2. Decomposition: AB → A + B (one substance breaks apart)
3. Single replacement: A + BC → AC + B (one element replaces another)
4. Double replacement: AB + CD → AD + CB (ions swap partners)
5. Combustion: Fuel + O₂ → CO₂ + H₂O (burning in oxygen)
      """,
      additionalContent:
          "Combustion reactions always require oxygen and produce CO₂ and H₂O (for hydrocarbons).",
    ),
    LessonSection(
      content: """
Energy in reactions:
 
Exothermic: releases energy (heat) to surroundings.
- ΔH < 0
- Examples: combustion, respiration
 
Endothermic: absorbs energy from surroundings.
- ΔH > 0
- Examples: photosynthesis, dissolving ammonium nitrate
 
Activation energy is the minimum energy needed to start a reaction.
      """,
      message: "Exo = energy exits. Endo = energy enters.",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "Which type of reaction does \$2H_2 + O_2 \\rightarrow 2H_2O\$ represent?",
      type: QuestionType.multipleChoice,
      options: [
        "Decomposition",
        "Combustion",
        "Synthesis",
        "Single replacement",
      ],
      answer: "Synthesis",
      hint: "Two substances (H₂ and O₂) combine to form one product (H₂O).",
    ),
    QuizProblem(
      question:
          "True or False: Exothermic reactions absorb heat from their surroundings.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "Exothermic reactions release heat. Endothermic reactions absorb heat.",
    ),
    QuizProblem(
      question:
          "Balance the equation: \$\\mathrm{Fe} + \\mathrm{O_2} \\rightarrow \\mathrm{Fe_2O_3}\$. What is the coefficient of O₂?",
      type: QuestionType.typing,
      answer: "\$3\$",
      hint: "Balanced: 4Fe + 3O₂ → 2Fe₂O₃. The coefficient of O₂ is 3.",
    ),
  ],
);

final moleStoichiometryLesson = Lesson(
  title: "Mole Concept and Stoichiometry",
  description:
      "Use the mole and stoichiometry to calculate quantities in chemical reactions.",
  sections: [
    LessonSection(
      content: """
The mole is the SI unit for amount of substance.
 
1 mole = \$6.022 \\times 10^{23}\$ particles (Avogadro's number, \$N_A\$)
 
This means 1 mole of any substance contains \$6.022 \\times 10^{23}\$ atoms, molecules, or formula units.
 
Molar mass = mass of 1 mole of a substance (in g/mol)
- Molar mass of H₂O = 2(1) + 16 = 18 g/mol
 
Key formula:
\$n = \\frac{m}{M}\$
 
where \$n\$ = moles, \$m\$ = mass (g), \$M\$ = molar mass (g/mol)
      """,
      message:
          "The mole is the chemist's counting unit — like a dozen, but for atoms!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Moles to Mass",
          prompt:
              "Increase the number of moles of H₂O (molar mass = 18 g/mol) and watch the mass grow.",
          valueLabel: "Moles (n)",
          valueUnit: " mol",
          minValue: 1,
          maxValue: 10,
          initialValue: 1,
          targetMin: 4,
          targetMax: 8,
          outputLabel: "Mass (g)",
          outputMultiplier: 18,
          revealOnComplete:
              "Correct. Mass = moles × molar mass. Each extra mole adds 18 g of water.",
        ),
      ],
    ),
    LessonSection(
      content: """
Stoichiometry uses balanced equations to calculate the amounts of reactants and products.
 
The coefficients in a balanced equation give the mole ratio between substances.
 
Example:
\$2H_2 + O_2 \\rightarrow 2H_2O\$
 
Mole ratios:
- 2 mol H₂ : 1 mol O₂ : 2 mol H₂O
- 4 g H₂ reacts with 32 g O₂ to give 36 g H₂O
      """,
      additionalContent:
          "Always start stoichiometry problems by converting grams → moles using molar mass.",
    ),
    LessonSection(
      content: """
Limiting reagent: the reactant that is completely consumed first, limiting the amount of product formed.
 
Excess reagent: the reactant left over after the reaction.
 
Steps to find the limiting reagent:
1. Convert given masses to moles.
2. Divide moles by the stoichiometric coefficient.
3. The smaller value corresponds to the limiting reagent.
 
Percent yield = \$\\frac{\\text{actual yield}}{\\text{theoretical yield}} \\times 100\\%\$
      """,
      message: "The limiting reagent is the 'bottleneck' of the reaction!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "How many moles are in \$36\\ \\mathrm{g}\$ of water (\$M_{H_2O}=18\\ \\mathrm{g/mol}\$)?",
      type: QuestionType.typing,
      answer: "\$2\$",
      hint: "n = m / M = 36 / 18.",
    ),
    QuizProblem(
      question:
          "True or False: The limiting reagent is the reactant present in the largest amount by mass.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "It depends on mole ratios, not just mass — you must convert and compare.",
    ),
    QuizProblem(
      question:
          "In the reaction \$N_2 + 3H_2 \\rightarrow 2NH_3\$, what is the mole ratio of \$H_2\$ to \$NH_3\$?",
      type: QuestionType.multipleChoice,
      options: ["1:1", "3:2", "2:3", "1:2"],
      answer: "3:2",
      hint:
          "Read the coefficients directly from the balanced equation: 3 mol H₂ produces 2 mol NH₃.",
    ),
  ],
);

final chemistryLessons = [
  introChemistryLesson,
  unitsMeasurementLesson,
  atomicStructureLesson,
  chemicalBondingLesson,
  inorganicNamingLesson,
  chemicalReactionsLesson,
  moleStoichiometryLesson,
];
