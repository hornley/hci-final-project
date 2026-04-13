import '../../models/lesson.dart';
import '../../models/quiz_problem.dart';

final integrationBasicsLesson = Lesson(
  title: "Integration Basics",
  description:
      "Learn the concept of integrals as the reverse of differentiation.",
  sections: [
    LessonSection(
      content: """
Integration is the reverse process of differentiation.
The indefinite integral of a function \$f(x)\$ is \$F(x) + C\$, where \$F'(x)=f(x)\$ and \$C\$ is the constant of integration.
      """,
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Power Rule Explorer",
          prompt:
              "Move n and observe how integrating x^n changes to x^(n+1)/(n+1).",
          valueLabel: "Exponent n",
          minValue: 0,
          maxValue: 6,
          initialValue: 1,
          targetMin: 2,
          targetMax: 4,
          outputLabel: "New exponent after integration",
          outputMultiplier: 1,
          revealOnComplete:
              "Great. Integration raises the exponent by 1 and divides by the new exponent.",
        ),
      ],
    ),
    LessonSection(
      content: """
Notation: \$\$\\int f(x)\\,dx\$\$ represents the integral of \$f(x)\$ with respect to \$x\$.
      """,
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.chartExperiment,
          title: "Area Accumulator",
          prompt:
              "Adjust x and watch how accumulated area grows for a simple positive function.",
          valueLabel: "Upper bound x",
          valueUnit: "",
          minValue: 0,
          maxValue: 5,
          initialValue: 1,
          outputLabel: "Accumulated area (relative)",
          outputMultiplier: 1.5,
          targetMin: 2,
          targetMax: 4,
          revealOnComplete:
              "Nice observation. As the bound increases, total accumulated area increases too.",
        ),
      ],
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Find the indefinite integral of \$f(x)=2x\$.",
      type: QuestionType.multipleChoice,
      options: ["\$x^2+C\$", "\$2x+C\$", "\$x^3+C\$", "\$x^2\$"],
      answer: "\$x^2+C\$",
      hint: "Use the power rule for integrals and remember + C.",
    ),
    QuizProblem(
      question: "True or False: Integration always reverses differentiation.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "Indefinite integration is an antiderivative operation.",
    ),
    QuizProblem(
      question:
          "What does the constant \$C\$ represent in an indefinite integral?",
      type: QuestionType.multipleChoice,
      options: [
        "The lower bound of integration",
        "The constant of integration",
        "The derivative of the function",
        "The area under the curve",
      ],
      answer: "The constant of integration",
      hint:
          "Since differentiation loses constants, integration must account for all possible ones.",
    ),
  ],
);

final generalPowerRuleLesson = Lesson(
  title: "General Power Rule",
  description:
      "Apply the general power rule to integrate polynomial expressions.",
  sections: [
    LessonSection(
      content: """
The General Power Rule for integration states:

\$\$\\int x^n\\,dx = \\frac{x^{n+1}}{n+1} + C, \\quad n \\neq -1\$\$

Steps:
1. Add 1 to the exponent.
2. Divide the coefficient by the new exponent.
3. Add the constant of integration \$C\$.
      """,
      message: "Raise the power by 1, divide by the new power — that's all!",
      additionalContent:
          "This rule applies to any real number exponent except n = -1, which is handled separately.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Power Rule in Action",
          prompt:
              "Set the exponent n and observe the resulting new exponent after applying the power rule.",
          valueLabel: "Exponent n",
          minValue: 1,
          maxValue: 8,
          initialValue: 2,
          targetMin: 4,
          targetMax: 7,
          outputLabel: "New exponent (n+1)",
          outputMultiplier: 1,
          revealOnComplete:
              "Correct. The new exponent is always n+1. Remember to also divide by that new exponent.",
        ),
      ],
    ),
    LessonSection(
      content: """
Examples:

\$\\int x^3\\,dx = \\frac{x^4}{4} + C\$

\$\\int 5x^2\\,dx = \\frac{5x^3}{3} + C\$

\$\\int (3x^4 + 2x)\\,dx = \\frac{3x^5}{5} + x^2 + C\$

For sums and differences, integrate each term separately.
      """,
      additionalContent:
          "You can always verify your answer by differentiating it — you should get back the original function.",
    ),
    LessonSection(
      content: """
Special cases:

- \$\\int k\\,dx = kx + C\$ (constant rule — think of k as \$kx^0\$)
- \$\\int x^{1/2}\\,dx = \\frac{2}{3}x^{3/2} + C\$ (fractional exponents work too!)
- \$\\int x^{-2}\\,dx = -x^{-1} + C\$ (negative exponents are valid as long as \$n \\neq -1\$)
      """,
      message: "Fractional and negative exponents follow the exact same rule!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Evaluate \$\\int x^4\\,dx\$.",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\frac{x^5}{5} + C\$",
        "\$5x^4 + C\$",
        "\$\\frac{x^4}{4} + C\$",
        "\$x^5 + C\$",
      ],
      answer: "\$\\frac{x^5}{5} + C\$",
      hint:
          "Add 1 to the exponent (4→5), then divide by 5. Make sure 'frac{}{}' is used correctly if you think there is a fraction in the answer.",
    ),
    QuizProblem(
      question:
          "True or False: The general power rule applies when the exponent is \$n=-1\$.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "n = -1 is the one exception — it leads to a logarithmic result instead.",
    ),
    QuizProblem(
      question: "Which is the correct integral of \$6x^2\$?",
      type: QuestionType.multipleChoice,
      options: ["\$6x^3+C\$", "\$2x^3+C\$", "\$3x^2+C\$", "\$12x+C\$"],
      answer: "\$2x^3+C\$",
      hint: "Raise exponent by 1 (2→3), then divide 6 by the new exponent 3.",
    ),
  ],
);

final chainRuleIntegrationLesson = Lesson(
  title: "Chain Rule for Integration",
  description:
      "Integrate composite algebraic and trigonometric functions using substitution.",
  sections: [
    LessonSection(
      content: """
When integrating composite functions (a function inside another function), we use the technique called u-substitution, which is the reverse of the chain rule in differentiation.

General form:
\$\$\\int f(g(x))\\cdot g'(x)\\,dx = F(g(x)) + C\$\$

The key is identifying the inner function \$u = g(x)\$ and its derivative \$du = g'(x)\\,dx\$.
      """,
      message: "Spot the inner function, substitute it as u, then integrate!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Order the U-Substitution Steps",
          prompt:
              "Drag the steps into the correct order for performing u-substitution.",
          draggableOptions: [
            "Substitute back u = g(x)",
            "Let u = inner function g(x)",
            "Integrate in terms of u",
            "Find du = g'(x) dx",
          ],
          expectedOrder: [
            "Let u = inner function g(x)",
            "Find du = g'(x) dx",
            "Integrate in terms of u",
            "Substitute back u = g(x)",
          ],
          revealOnComplete:
              "Well done! Those four steps are the complete u-substitution process.",
        ),
      ],
    ),
    LessonSection(
      content: """
Algebraic Example:

\$\\int (2x+1)^4\\,dx\$

Let \$u = 2x+1\$, then \$du = 2\\,dx\$, so \$dx = \\frac{du}{2}\$.

\$= \\int u^4 \\cdot \\frac{du}{2} = \\frac{u^5}{10} + C = \\frac{(2x+1)^5}{10} + C\$
      """,
      additionalContent:
          "Always adjust for the coefficient of dx by dividing — don't forget this step!",
    ),
    LessonSection(
      content: """
Trigonometric Example:

\$\\int \\cos(3x)\\,dx\$

Let \$u = 3x\$, so \$du = 3\\,dx\$, meaning \$dx = \\frac{du}{3}\$.

\$= \\int \\cos(u)\\cdot\\frac{du}{3} = \\frac{\\sin(u)}{3} + C = \\frac{\\sin(3x)}{3} + C\$
      """,
      message:
          "The 3 in 3x shows up in the denominator after substitution — always account for it!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Evaluate \$\\int (3x+2)^3\\,dx\$.",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\frac{(3x+2)^4}{12} + C\$",
        "\$\\frac{(3x+2)^4}{4} + C\$",
        "\$\\frac{(3x+2)^3}{3} + C\$",
        "\$\\frac{(3x+2)^5}{15} + C\$",
      ],
      answer: "\$\\frac{(3x+2)^4}{12} + C\$",
      hint:
          "Let u = 3x+2, du = 3 dx. Raise power by 1, divide by 4, then divide by 3. Make sure 'frac{}{}' is used correctly if you think there is a fraction in the answer.",
    ),
    QuizProblem(
      question:
          "True or False: U-substitution is the integration counterpart of the chain rule.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint:
          "Just as the chain rule differentiates composite functions, u-sub integrates them.",
    ),
    QuizProblem(
      question: "What is \$\\int \\sin(5x)\\,dx\$?",
      type: QuestionType.multipleChoice,
      options: [
        "\$-5\\cos(5x)+C\$",
        "\$5\\cos(5x)+C\$",
        "\$-\\frac{\\cos(5x)}{5}+C\$",
        "\$\\frac{\\cos(5x)}{5}+C\$",
      ],
      answer: "\$-\\frac{\\cos(5x)}{5}+C\$",
      hint:
          "Integral of sin(u) is -cos(u). Divide by the inner derivative 5. Make sure 'frac{}{}' is used correctly if you think there is a fraction in the answer.",
    ),
  ],
);

final powerRuleNegOneLesson = Lesson(
  title: "Power Rule: Negative One Exponent",
  description:
      "Integrate expressions with exponent -1 using the natural logarithm.",
  sections: [
    LessonSection(
      content: """
The general power rule \$\\int x^n\\,dx = \\frac{x^{n+1}}{n+1}+C\$ breaks down at \$n=-1\$ because division by zero would occur.

Instead, the special case is:

\$\$\\int \\frac{1}{x}\\,dx = \\int x^{-1}\\,dx = \\ln|x| + C\$\$

The absolute value is necessary because the logarithm is only defined for positive numbers, but \$\\frac{1}{x}\$ can have negative x values.
      """,
      message: "Whenever you see 1/x or x⁻¹, think natural log!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.chartExperiment,
          title: "Logarithmic Growth",
          prompt:
              "Increase x and observe how ln(x) grows — slowly but without bound.",
          valueLabel: "x",
          valueUnit: "",
          minValue: 1,
          maxValue: 10,
          initialValue: 1,
          targetMin: 5,
          targetMax: 9,
          outputLabel: "ln(x) value (relative)",
          outputMultiplier: 0.3,
          revealOnComplete:
              "Good. The natural log grows slowly — that reflects how the area under 1/x accumulates.",
        ),
      ],
    ),
    LessonSection(
      content: """
With u-substitution:

\$\$\\int \\frac{1}{ax+b}\\,dx = \\frac{1}{a}\\ln|ax+b| + C\$\$

Example:
\$\\int \\frac{1}{3x+1}\\,dx\$

Let \$u = 3x+1\$, \$du = 3\\,dx\$:

\$= \\frac{1}{3}\\ln|3x+1| + C\$
      """,
      additionalContent:
          "Always include the absolute value bars when writing ln results from integration.",
    ),
    LessonSection(
      content: """
This rule also appears when integrating rational functions where the numerator is the derivative of the denominator:

\$\$\\int \\frac{f'(x)}{f(x)}\\,dx = \\ln|f(x)| + C\$\$

Example: \$\\int \\frac{2x}{x^2+1}\\,dx = \\ln|x^2+1| + C\$

(Here the numerator \$2x\$ is exactly the derivative of \$x^2+1\$.)
      """,
      message:
          "If the top is the derivative of the bottom — it's a natural log!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Evaluate \$\\int \\frac{1}{x}\\,dx\$.",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\ln|x|+C\$",
        "\$\\frac{1}{x}+C\$",
        "\$x+C\$",
        "\$\\frac{x^0}{0}+C\$",
      ],
      answer: "\$\\ln|x|+C\$",
      hint: "This is the special case of the power rule where n = -1.",
    ),
    QuizProblem(
      question:
          "True or False: \$\\int x^{-1}\\,dx = \\frac{x^0}{0}+C\$ is a valid result.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "Division by zero is undefined — hence the special logarithmic rule.",
    ),
    QuizProblem(
      question: "What is \$\\int \\frac{1}{2x+3}\\,dx\$?",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\ln|2x+3|+C\$",
        "\$2\\ln|2x+3|+C\$",
        "\$\\frac{1}{2}\\ln|2x+3|+C\$",
        "\$\\frac{-1}{(2x+3)^2}+C\$",
      ],
      answer: "\$\\frac{1}{2}\\ln|2x+3|+C\$",
      hint: "Divide by the inner derivative (2) when applying u-substitution.",
    ),
  ],
);

final definiteIntegralsLesson = Lesson(
  title: "Definite Integrals",
  description: "Compute the area under a curve using definite integrals.",
  sections: [
    LessonSection(
      content: """
A definite integral \$\$\\int_a^b f(x)\\,dx\$\$ calculates the net area under \$f(x)\$ from \$x=a\$ to \$x=b\$.
It has a numeric value, unlike indefinite integrals.
      """,
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Bound Sensitivity",
          prompt:
              "Move the upper bound b and inspect how the definite integral value changes.",
          valueLabel: "Upper bound b",
          minValue: 0,
          maxValue: 6,
          initialValue: 2,
          targetMin: 3,
          targetMax: 5,
          outputLabel: "Relative integral value",
          outputMultiplier: 2,
          revealOnComplete:
              "Exactly. Definite integrals return one numeric value for chosen bounds.",
        ),
      ],
    ),
    LessonSection(
      content: """
Fundamental Theorem of Calculus:
If \$F'(x)=f(x)\$, then \$\$\\int_a^b f(x)\\,dx = F(b)-F(a)\$\$
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Compute \$\\int_0^2 3x^2\\,dx\$.",
      type: QuestionType.typing,
      answer: "\$8\$",
      hint: "Find an antiderivative first, then evaluate upper minus lower.",
    ),
    QuizProblem(
      question: "True or False: Definite integrals give a numeric value.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "Definite integrals evaluate across bounds.",
    ),
    QuizProblem(
      question:
          "Using the Fundamental Theorem of Calculus, evaluate \$\\int_1^3 2x\\,dx\$.",
      type: QuestionType.typing,
      answer: "\$8\$",
      hint:
          "Antiderivative is x². Evaluate at 3 then subtract value at 1: 9 - 1 = 8.",
    ),
  ],
);

final oddEvenFunctionsLesson = Lesson(
  title: "Odd and Even Functions",
  description:
      "Use symmetry properties of odd and even functions to simplify definite integrals.",
  sections: [
    LessonSection(
      content: """
Functions can have useful symmetry properties that simplify integration over symmetric intervals \$[-a, a]\$:

Even function: \$f(-x) = f(x)\$ — symmetric about the y-axis.
\$\$\\int_{-a}^{a} f(x)\\,dx = 2\\int_0^a f(x)\\,dx\$\$

Odd function: \$f(-x) = -f(x)\$ — symmetric about the origin.
\$\$\\int_{-a}^{a} f(x)\\,dx = 0\$\$
      """,
      message: "Even? Double it. Odd? It cancels to zero!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Classify the Functions",
          prompt:
              "Drag these functions into the correct category: Even or Odd.",
          draggableOptions: [
            "f(x) = x³ (Odd)",
            "f(x) = x² (Even)",
            "f(x) = sin(x) (Odd)",
            "f(x) = cos(x) (Even)",
          ],
          expectedOrder: [
            "f(x) = x² (Even)",
            "f(x) = cos(x) (Even)",
            "f(x) = x³ (Odd)",
            "f(x) = sin(x) (Odd)",
          ],
          revealOnComplete:
              "Correct! x² and cos(x) are even; x³ and sin(x) are odd.",
        ),
      ],
    ),
    LessonSection(
      content: """
How to test a function:

1. Replace \$x\$ with \$-x\$.
2. Simplify the result.
3. If you get the original function → Even.
   If you get the negative of the original → Odd.
   If neither → Neither (no special shortcut).
      """,
      additionalContent:
          "Most polynomial functions with only even powers are even; those with only odd powers are odd.",
    ),
    LessonSection(
      content: """
Practical examples:

\$\\int_{-3}^{3} x^5\\,dx = 0\$ (odd function)

\$\\int_{-2}^{2} x^2\\,dx = 2\\int_0^2 x^2\\,dx = 2\\cdot\\frac{8}{3} = \\frac{16}{3}\$ (even function)

These shortcuts save significant computation time!
      """,
      message:
          "Always check for symmetry before evaluating — it can eliminate the work entirely!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: The definite integral of an odd function over a symmetric interval is always zero.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint:
          "The positive and negative areas cancel perfectly for odd functions.",
    ),
    QuizProblem(
      question: "What is \$\\int_{-4}^{4} x^3\\,dx\$?",
      type: QuestionType.typing,
      answer: "\$0\$",
      hint:
          "x³ is an odd function. Its integral over a symmetric interval is 0.",
    ),
    QuizProblem(
      question: "Which of the following is an even function?",
      type: QuestionType.multipleChoice,
      options: [
        "\$f(x)=x^3\$",
        "\$f(x)=\\sin(x)\$",
        "\$f(x)=x^2+4\$",
        "\$f(x)=x^5-x\$",
      ],
      answer: "\$f(x)=x^2+4\$",
      hint: "Check f(-x) = f(x). Only even powers and constants satisfy this.",
    ),
  ],
);

final changeLimitsLesson = Lesson(
  title: "Change of Limits",
  description:
      "Apply change of limits to simplify definite integrals under u-substitution.",
  sections: [
    LessonSection(
      content: """
When using u-substitution on a definite integral, you have two options:

Option 1: Substitute back to x and use original limits.
Option 2: Change the limits to match u — then you never need to substitute back.

Change of limits formula:
When \$u = g(x)\$:
- New lower limit: \$u = g(a)\$
- New upper limit: \$u = g(b)\$
      """,
      message:
          "Changing limits lets you finish the problem entirely in u — faster and cleaner!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Steps for Change of Limits",
          prompt:
              "Drag these steps into the correct order when applying change of limits.",
          draggableOptions: [
            "Evaluate using new limits in u",
            "Let u = g(x) and find du",
            "Change limits: u(a) and u(b)",
            "Rewrite the integral entirely in u",
          ],
          expectedOrder: [
            "Let u = g(x) and find du",
            "Change limits: u(a) and u(b)",
            "Rewrite the integral entirely in u",
            "Evaluate using new limits in u",
          ],
          revealOnComplete:
              "Correct! Follow these steps and you never need to convert back to x.",
        ),
      ],
    ),
    LessonSection(
      content: """
Example:

\$\\int_0^1 2x(x^2+1)^3\\,dx\$

Let \$u = x^2+1\$, \$du = 2x\\,dx\$.

Change limits:
- When \$x=0\$: \$u=0^2+1=1\$
- When \$x=1\$: \$u=1^2+1=2\$

New integral: \$\\int_1^2 u^3\\,du = \\left[\\frac{u^4}{4}\\right]_1^2 = \\frac{16}{4}-\\frac{1}{4} = \\frac{15}{4}\$
      """,
      additionalContent:
          "Notice we never converted back to x — the new limits handled everything.",
    ),
    LessonSection(
      content: """
Why change limits?

- Avoids the extra step of substituting back.
- Reduces chance of error.
- Makes the evaluation cleaner, especially in trigonometric and exponential integrals.

Always double-check your new limits by plugging the original limits into u = g(x).
      """,
      message: "Change of limits = less work, fewer mistakes!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "For \$\\int_0^2 2x(x^2+3)^4\\,dx\$ with \$u=x^2+3\$, what are the new limits?",
      type: QuestionType.typing,
      answer: "\$3\$ to \$7\$",
      hint: "Plug x=0 into u=x²+3 for lower, and x=2 for upper.",
    ),
    QuizProblem(
      question:
          "True or False: When using change of limits, you must still substitute back in terms of x before evaluating.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "The whole point of changing limits is to avoid substituting back to x.",
    ),
    QuizProblem(
      question:
          "For \$u=3x+1\$ with \$x\$ going from \$0\$ to \$2\$, what is the new upper limit?",
      type: QuestionType.multipleChoice,
      options: ["\$2\$", "\$5\$", "\$7\$", "\$6\$"],
      answer: "\$7\$",
      hint: "Substitute x=2 into u = 3(2)+1.",
    ),
  ],
);

final trigIntegrationLesson = Lesson(
  title: "Integration of Trigonometric Functions",
  description:
      "Integrate standard trigonometric functions using known formulas.",
  sections: [
    LessonSection(
      content: """
Standard trigonometric integration formulas:

\$\\int \\sin(x)\\,dx = -\\cos(x) + C\$
\$\\int \\cos(x)\\,dx = \\sin(x) + C\$
\$\\int \\sec^2(x)\\,dx = \\tan(x) + C\$
\$\\int \\csc^2(x)\\,dx = -\\cot(x) + C\$
\$\\int \\sec(x)\\tan(x)\\,dx = \\sec(x) + C\$
\$\\int \\csc(x)\\cot(x)\\,dx = -\\csc(x) + C\$
      """,
      message: "These 6 formulas are the foundation — memorize them!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Match Trig Integrals",
          prompt:
              "Drag the correct antiderivatives to match their integrands in order.",
          draggableOptions: [
            "sec²(x) → tan(x) + C",
            "sin(x) → -cos(x) + C",
            "cos(x) → sin(x) + C",
          ],
          expectedOrder: [
            "sin(x) → -cos(x) + C",
            "cos(x) → sin(x) + C",
            "sec²(x) → tan(x) + C",
          ],
          revealOnComplete:
              "Correct! These three are the most frequently used trig integral formulas.",
        ),
      ],
    ),
    LessonSection(
      content: """
Combining with u-substitution:

\$\\int \\sin(4x)\\,dx\$

Let \$u=4x\$, \$du=4\\,dx\$:

\$= \\frac{1}{4}\\int \\sin(u)\\,du = -\\frac{\\cos(4x)}{4} + C\$

The same idea applies to all six standard formulas.
      """,
      additionalContent:
          "Always divide by the inner derivative when the argument is a linear expression like 4x or 3x+1.",
    ),
    LessonSection(
      content: """
Tips for remembering:

- \$\\sin \\rightarrow -\\cos\$ (note the negative sign!)
- \$\\cos \\rightarrow \\sin\$ (positive)
- \$\\sec^2 \\rightarrow \\tan\$

A common mistake is forgetting the negative in \$\\int \\sin(x)\\,dx = -\\cos(x) + C\$.

Double-check by differentiating: \$\\frac{d}{dx}(-\\cos x) = \\sin x\$ ✓
      """,
      message:
          "Always verify by differentiating your answer — trig signs are tricky!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Evaluate \$\\int \\cos(x)\\,dx\$.",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\sin(x)+C\$",
        "\$-\\sin(x)+C\$",
        "\$\\cos(x)+C\$",
        "\$-\\cos(x)+C\$",
      ],
      answer: "\$\\sin(x)+C\$",
      hint: "The integral of cos(x) is directly one of the standard formulas.",
    ),
    QuizProblem(
      question: "True or False: \$\\int \\sin(x)\\,dx = \\cos(x) + C\$.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint: "There should be a negative sign: the answer is -cos(x) + C.",
    ),
    QuizProblem(
      question: "What is \$\\int \\sec^2(x)\\,dx\$?",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\sec(x)\\tan(x)+C\$",
        "\$\\tan(x)+C\$",
        "\$\\cos^2(x)+C\$",
        "\$-\\cot(x)+C\$",
      ],
      answer: "\$\\tan(x)+C\$",
      hint:
          "sec²(x) is the derivative of tan(x) — so the integral reverses to tan(x).",
    ),
  ],
);

final exponentialIntegrationLesson = Lesson(
  title: "Integration of Exponential Functions",
  description: "Integrate natural and general exponential functions.",
  sections: [
    LessonSection(
      content: """
The natural exponential function is its own antiderivative:

\$\$\\int e^x\\,dx = e^x + C\$\$

For a scaled exponent:
\$\$\\int e^{ax}\\,dx = \\frac{e^{ax}}{a} + C\$\$

This follows directly from u-substitution with \$u = ax\$.
      """,
      message:
          "e^x is special — differentiating or integrating it gives itself!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.chartExperiment,
          title: "Exponential Growth",
          prompt:
              "Increase x and observe how rapidly e^x (and its accumulated area) grows.",
          valueLabel: "x",
          valueUnit: "",
          minValue: 0,
          maxValue: 5,
          initialValue: 1,
          targetMin: 3,
          targetMax: 5,
          outputLabel: "e^x value (relative area)",
          outputMultiplier: 1.5,
          revealOnComplete:
              "Remarkable! The area under e^x grows just as fast as e^x itself — because they are the same function.",
        ),
      ],
    ),
    LessonSection(
      content: """
For general base exponentials (\$a > 0,\\ a \\neq 1\$):

\$\$\\int a^x\\,dx = \\frac{a^x}{\\ln(a)} + C\$\$

Example:
\$\\int 2^x\\,dx = \\frac{2^x}{\\ln 2} + C\$

Note: as \$a \\to e\$, \$\\ln(a) \\to 1\$, recovering the \$e^x\$ rule.
      """,
      additionalContent:
          "The ln(a) in the denominator appears because differentiating a^x gives a^x · ln(a).",
    ),
    LessonSection(
      content: """
Combined examples with u-substitution:

\$\\int e^{3x+2}\\,dx\$

Let \$u = 3x+2\$, \$du = 3\\,dx\$:

\$= \\frac{1}{3}e^{3x+2} + C\$

\$\\int x\\cdot e^{x^2}\\,dx\$

Let \$u = x^2\$, \$du = 2x\\,dx\$:

\$= \\frac{1}{2}e^{x^2} + C\$
      """,
      message:
          "Spot the inner function of the exponent and apply u-substitution!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Evaluate \$\\int e^{5x}\\,dx\$.",
      type: QuestionType.multipleChoice,
      options: [
        "\$\\frac{e^{5x}}{5}+C\$",
        "\$5e^{5x}+C\$",
        "\$e^{5x}+C\$",
        "\$\\frac{e^x}{5}+C\$",
      ],
      answer: "\$\\frac{e^{5x}}{5}+C\$",
      hint: "Divide by the coefficient of x in the exponent.",
    ),
    QuizProblem(
      question: "True or False: \$\\int e^x\\,dx = e^x + C\$.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "The natural exponential function is its own antiderivative.",
    ),
    QuizProblem(
      question: "What is \$\\int 3^x\\,dx\$?",
      type: QuestionType.multipleChoice,
      options: [
        "\$x \\cdot 3^{x-1}+C\$",
        "\$3^x \\cdot \\ln(3)+C\$",
        "\$\\frac{3^x}{\\ln(3)}+C\$",
        "\$\\frac{3^x}{3}+C\$",
      ],
      answer: "\$\\frac{3^x}{\\ln(3)}+C\$",
      hint: "For general base a, divide by ln(a).",
    ),
  ],
);

final integralCalculusLessons = [
  integrationBasicsLesson,
  generalPowerRuleLesson,
  chainRuleIntegrationLesson,
  powerRuleNegOneLesson,
  definiteIntegralsLesson,
  oddEvenFunctionsLesson,
  changeLimitsLesson,
  trigIntegrationLesson,
  exponentialIntegrationLesson,
];
