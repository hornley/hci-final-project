import '../../models/lesson.dart';
import '../../models/quiz_problem.dart';

final mechanicsLesson = Lesson(
  title: "Mechanics",
  description: "Understand motion, force, and Newton's laws.",
  sections: [
    LessonSection(
      content: """
      Mechanics studies motion and forces on objects.
      Newton's laws:
      1. An object remains at rest or in uniform motion unless acted upon.
      2. F = ma, force equals mass times acceleration.
      3. For every action, there is an equal and opposite reaction.
      """,
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.chartExperiment,
          title: "Force Experiment",
          prompt:
              "Adjust acceleration and observe how force changes for a 2kg object.",
          valueLabel: "Acceleration",
          valueUnit: " m/s²",
          minValue: 0,
          maxValue: 10,
          initialValue: 1,
          outputLabel: "Force (N)",
          outputMultiplier: 2,
          targetMin: 3,
          targetMax: 6,
          revealOnComplete:
              "Great. You just observed the linear relationship in F = ma.",
        ),
      ],
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "Compute the force for \$m=2\,\\mathrm{kg}\$, \$a=3\,\\mathrm{m/s^2}\$.",
      type: QuestionType.typing,
      answer: "\$6\$",
      hint: "Use Newton's second law: F = m * a.",
    ),
    QuizProblem(
      question: "True or False: For every action, there is no reaction.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint: "Newton's third law says action and reaction come in pairs.",
    ),
  ],
);

final newtonFirstLawLesson = Lesson(
  title: "Newton's First Law",
  description: "Understand inertia and how objects resist changes in motion.",
  sections: [
    LessonSection(
      content: """
Newton's First Law states that an object at rest stays at rest, and an object in motion stays in motion at the same speed and direction, unless acted upon by an unbalanced external force.

This property of matter is called inertia — the tendency to resist any change in its state of motion.
      """,
      message:
          "Think of a book sitting on a table. It won't move unless you push it!",
      additionalContent:
          "Inertia is not a force. It is a property of matter that describes how much it resists acceleration.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Mass & Inertia",
          prompt:
              "Increase the mass and observe how much harder it becomes to change the object's motion.",
          valueLabel: "Mass",
          valueUnit: " kg",
          minValue: 1,
          maxValue: 10,
          initialValue: 1,
          targetMin: 5,
          targetMax: 9,
          outputLabel: "Inertia (resistance to change)",
          outputMultiplier: 1,
          revealOnComplete:
              "Exactly. More mass means more inertia — the object resists changes in motion more strongly.",
        ),
      ],
    ),
    LessonSection(
      content: """
A net force of zero does not mean there are no forces. It means all forces are balanced.

Examples of balanced forces:
- A book resting on a table (gravity balanced by normal force)
- A car moving at constant speed on a straight road (engine force balanced by friction)
      """,
      message: "Zero net force = constant motion (or rest). Not zero forces!",
    ),
    LessonSection(
      content: """
Real-world examples of inertia:
- Passengers lurch forward when a bus suddenly brakes.
- A tablecloth pulled quickly leaves dishes in place.
- Satellites orbit indefinitely because there is no air friction in space.
      """,
      additionalContent:
          "The greater the mass of an object, the greater its inertia, and the harder it is to start or stop its motion.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Order the Inertia Concept",
          prompt:
              "Drag these phrases into the correct logical order for Newton's First Law.",
          draggableOptions: [
            "unless acted on by a net force",
            "An object at rest stays at rest",
            "and an object in motion stays in motion",
          ],
          expectedOrder: [
            "An object at rest stays at rest",
            "and an object in motion stays in motion",
            "unless acted on by a net force",
          ],
          revealOnComplete:
              "Well done! That is the complete statement of Newton's First Law.",
        ),
      ],
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: An object moving at constant velocity has a net force acting on it.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "Constant velocity means no change in motion — so net force is zero.",
    ),
    QuizProblem(
      question:
          "Which property of matter causes it to resist changes in motion?",
      type: QuestionType.multipleChoice,
      options: ["Gravity", "Inertia", "Friction", "Tension"],
      answer: "Inertia",
      hint: "Newton's First Law introduces this property by name.",
    ),
    QuizProblem(
      question:
          "A \$4\,\\mathrm{kg}\$ object is at rest. What net force is needed to keep it at rest?",
      type: QuestionType.typing,
      answer: "\$0\$",
      hint: "By Newton's First Law, no net force is needed to maintain rest.",
    ),
  ],
);

final newtonSecondLawLesson = Lesson(
  title: "Newton's Second Law",
  description: "Learn how force, mass, and acceleration are related.",
  sections: [
    LessonSection(
      content: """
Newton's Second Law states that the acceleration of an object depends on the net force applied to it and its mass.

The formula is:
\$F = ma\$

Where:
- \$F\$ = net force (Newtons, N)
- \$m\$ = mass (kilograms, kg)
- \$a\$ = acceleration (m/s²)
      """,
      message: "More force = more acceleration. More mass = less acceleration.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.chartExperiment,
          title: "Force vs. Acceleration",
          prompt:
              "Keep mass at 3 kg. Increase the force and watch acceleration grow.",
          valueLabel: "Force",
          valueUnit: " N",
          minValue: 0,
          maxValue: 30,
          initialValue: 3,
          targetMin: 15,
          targetMax: 27,
          outputLabel: "Acceleration (m/s²)",
          outputMultiplier: 0.333,
          revealOnComplete:
              "Correct. Doubling the force doubles the acceleration when mass is constant — that's F = ma.",
        ),
      ],
    ),
    LessonSection(
      content: """
Rearranging \$F = ma\$:
- To find acceleration: \$a = \\frac{F}{m}\$
- To find mass: \$m = \\frac{F}{a}\$

The direction of acceleration is always the same as the direction of the net force.
      """,
      additionalContent:
          "If multiple forces act on an object, use the vector sum (net force) in the formula.",
    ),
    LessonSection(
      content: """
Examples:
- A car engine applies 4000 N to a 1000 kg car → \$a = 4\,\\mathrm{m/s^2}\$
- The same force on a 2000 kg car → \$a = 2\,\\mathrm{m/s^2}\$

Greater mass resists acceleration more.
      """,
      message: "Mass acts as a brake on acceleration!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "A net force of \$20\,\\mathrm{N}\$ acts on a \$4\,\\mathrm{kg}\$ object. What is the acceleration?",
      type: QuestionType.typing,
      answer: "\$5\$",
      hint: "Use a = F / m.",
    ),
    QuizProblem(
      question:
          "True or False: Acceleration is in the opposite direction of the net force.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "Acceleration always points in the same direction as the net force.",
    ),
    QuizProblem(
      question: "Which formula correctly represents Newton's Second Law?",
      type: QuestionType.multipleChoice,
      options: [
        "\$F=mv\$",
        "\$F=ma\$",
        "\$F=\\frac{m}{a}\$",
        "\$F=\\frac{a}{m}\$",
      ],
      answer: "\$F=ma\$",
      hint: "Force equals mass times acceleration.",
    ),
  ],
);

final newtonThirdLawLesson = Lesson(
  title: "Newton's Third Law",
  description: "Explore action-reaction force pairs and their interactions.",
  sections: [
    LessonSection(
      content: """
Newton's Third Law states:
"For every action, there is an equal and opposite reaction."

Whenever object A exerts a force on object B, object B exerts an equal force in the opposite direction on object A.

These forces are called action-reaction pairs.
      """,
      message: "Forces always come in pairs — you can never have just one!",
      additionalContent:
          "Important: Action and reaction forces act on different objects, so they do NOT cancel each other out.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.dragArrangement,
          title: "Identify the Reaction",
          prompt:
              "Drag the phrases to match: Action → Rocket pushes gas backward. Reaction → ?",
          draggableOptions: [
            "Gas pushes rocket forward",
            "Rocket slows down",
            "Gas disappears",
          ],
          expectedOrder: ["Gas pushes rocket forward"],
          revealOnComplete:
              "Correct! The gas being pushed back causes an equal and opposite push forward on the rocket — Newton's Third Law in action.",
        ),
      ],
    ),
    LessonSection(
      content: """
Common examples:
- Walking: your foot pushes backward on the ground; the ground pushes you forward.
- Swimming: you push water backward; water pushes you forward.
- A gun firing: the bullet is pushed forward; the gun recoils backward.
- Rocket propulsion: exhaust gas expelled downward pushes the rocket upward.
      """,
    ),
    LessonSection(
      content: """
Why don't action-reaction pairs cancel?

They act on different objects.

Example — a horse pulling a cart:
- Horse pulls cart forward (action on cart).
- Cart pulls horse backward (reaction on horse).

These do not cancel because they are on separate objects.
      """,
      message: "Same magnitude, opposite direction, but on different objects!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: Action and reaction forces act on the same object.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint: "They always act on two different objects.",
    ),
    QuizProblem(
      question:
          "A swimmer pushes the pool wall backward. What is the reaction force?",
      type: QuestionType.multipleChoice,
      options: [
        "The wall pulls the swimmer backward",
        "The wall pushes the swimmer forward",
        "The water pushes the swimmer down",
        "There is no reaction force",
      ],
      answer: "The wall pushes the swimmer forward",
      hint: "Reaction is equal in magnitude but opposite in direction.",
    ),
    QuizProblem(
      question:
          "If a \$70\,\\mathrm{kg}\$ person pushes a wall with \$50\,\\mathrm{N}\$, how much force does the wall exert back?",
      type: QuestionType.typing,
      answer: "\$50\$",
      hint:
          "Newton's Third Law — reaction force equals action force in magnitude.",
    ),
  ],
);

final torqueLesson = Lesson(
  title: "Torque",
  description: "Understand rotational force and how torque causes rotation.",
  sections: [
    LessonSection(
      content: """
Torque is the rotational equivalent of force. It measures how effectively a force causes an object to rotate around a pivot point (called the axis of rotation).

Formula:
\$\\tau = r \\times F \\times \\sin(\\theta)\$

Where:
- \$\\tau\$ = torque (Newton-meters, N·m)
- \$r\$ = distance from pivot to force application (meters)
- \$F\$ = applied force (Newtons)
- \$\\theta\$ = angle between the force and the lever arm
      """,
      message:
          "The further from the pivot you push, the more torque you create!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Lever Arm Explorer",
          prompt:
              "Keep force at 10 N. Increase the distance r from the pivot and watch torque grow.",
          valueLabel: "Distance r",
          valueUnit: " m",
          minValue: 0,
          maxValue: 5,
          initialValue: 1,
          targetMin: 3,
          targetMax: 5,
          outputLabel: "Torque (N·m)",
          outputMultiplier: 10,
          revealOnComplete:
              "Correct! Doubling the lever arm doubles the torque. That's why door handles are placed far from the hinge.",
        ),
      ],
    ),
    LessonSection(
      content: """
Maximum torque is achieved when the force is perpendicular to the lever arm (\$\\theta = 90°\$, so \$\\sin(90°) = 1\$).

If force is applied along the lever arm (\$\\theta = 0°\$), torque is zero — no rotation occurs.
      """,
      additionalContent:
          "This is why you push a door handle at 90° to the door, not parallel to it.",
    ),
    LessonSection(
      content: """
Everyday examples of torque:
- Turning a wrench: applying force far from the bolt creates more torque.
- Opening a door: easier when pushing at the edge far from the hinge.
- A seesaw: torque is balanced when both sides have equal \$r \\times F\$.
      """,
      message: "Torque = force with a twist — literally!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "A force of \$10\,\\mathrm{N}\$ is applied perpendicular to a lever \$2\,\\mathrm{m}\$ from the pivot. What is the torque?",
      type: QuestionType.typing,
      answer: "\$20\$",
      hint: "Use τ = r × F × sin(90°). sin(90°) = 1.",
    ),
    QuizProblem(
      question:
          "True or False: Torque is maximized when force is applied parallel to the lever arm.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint: "sin(0°) = 0, so parallel force produces zero torque.",
    ),
    QuizProblem(
      question: "What is the SI unit of torque?",
      type: QuestionType.multipleChoice,
      options: [
        "Joules (J)",
        "Newtons (N)",
        "Newton-meters (N·m)",
        "Watts (W)",
      ],
      answer: "Newton-meters (N·m)",
      hint: "Torque = force × distance.",
    ),
  ],
);

final workLesson = Lesson(
  title: "Work",
  description: "Learn what work means in physics and how to calculate it.",
  sections: [
    LessonSection(
      content: """
In physics, work is done when a force causes an object to move in the direction of the force.

Formula:
\$W = F \\cdot d \\cdot \\cos(\\theta)\$

Where:
- \$W\$ = work (Joules, J)
- \$F\$ = applied force (Newtons, N)
- \$d\$ = displacement (meters, m)
- \$\\theta\$ = angle between force and displacement
      """,
      message: "No displacement = no work, no matter how hard you push!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.chartExperiment,
          title: "Work vs. Displacement",
          prompt:
              "Apply a constant 5 N force. Increase displacement and watch work done grow.",
          valueLabel: "Displacement",
          valueUnit: " m",
          minValue: 0,
          maxValue: 10,
          initialValue: 1,
          targetMin: 5,
          targetMax: 9,
          outputLabel: "Work done (J)",
          outputMultiplier: 5,
          revealOnComplete:
              "Good observation. Work grows linearly with displacement when force is constant.",
        ),
      ],
    ),
    LessonSection(
      content: """
Key cases:
- \$\\theta = 0°\$: Force and displacement in the same direction → maximum work: \$W = Fd\$
- \$\\theta = 90°\$: Force perpendicular to displacement → zero work (e.g., carrying a bag horizontally)
- \$\\theta = 180°\$: Force and displacement opposite → negative work (e.g., friction slowing an object)
      """,
      additionalContent:
          "Negative work means the force removes energy from the object.",
    ),
    LessonSection(
      content: """
The work-energy theorem states:
The net work done on an object equals its change in kinetic energy.

\$W_{net} = \\Delta KE = \\frac{1}{2}mv_f^2 - \\frac{1}{2}mv_i^2\$
      """,
      message: "Work is the bridge between force and energy!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "A force of \$15\,\\mathrm{N}\$ moves an object \$4\,\\mathrm{m}\$ in the same direction. How much work is done?",
      type: QuestionType.typing,
      answer: "\$60\$",
      hint: "W = F × d × cos(0°) = F × d.",
    ),
    QuizProblem(
      question:
          "True or False: Carrying a heavy box horizontally at constant height does work against gravity.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint:
          "Gravity acts downward; horizontal displacement is perpendicular — cos(90°) = 0.",
    ),
    QuizProblem(
      question: "What is the SI unit of work?",
      type: QuestionType.multipleChoice,
      options: ["Newton (N)", "Watt (W)", "Joule (J)", "Pascal (Pa)"],
      answer: "Joule (J)",
      hint: "Work = force × distance. 1 J = 1 N·m.",
    ),
  ],
);

final energyLesson = Lesson(
  title: "Energy",
  description:
      "Explore kinetic energy, potential energy, and conservation of energy.",
  sections: [
    LessonSection(
      content: """
Energy is the capacity to do work. It exists in many forms. In mechanics, the two main types are:
 
Kinetic Energy (KE) — energy of motion:
\$KE = \\frac{1}{2}mv^2\$
 
Potential Energy (PE) — stored energy due to position (gravitational):
\$PE = mgh\$
 
Where \$m\$ = mass (kg), \$v\$ = velocity (m/s), \$g \\approx 9.8\,\\mathrm{m/s^2}\$, \$h\$ = height (m).
      """,
      message: "Moving → kinetic energy. Up high → potential energy.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Kinetic Energy Explorer",
          prompt:
              "Keep mass at 2 kg. Increase velocity and observe how KE grows rapidly.",
          valueLabel: "Velocity",
          valueUnit: " m/s",
          minValue: 0,
          maxValue: 10,
          initialValue: 1,
          targetMin: 5,
          targetMax: 9,
          outputLabel: "Kinetic Energy (J)",
          outputMultiplier: 1,
          revealOnComplete:
              "Notice how KE grows with the square of velocity — doubling speed quadruples kinetic energy!",
        ),
      ],
    ),
    LessonSection(
      content: """
Law of Conservation of Energy:
Energy cannot be created or destroyed — only converted from one form to another.
 
In a closed system (no friction):
\$KE + PE = \\text{constant}\$
 
Example — a falling ball:
- At the top: high PE, zero KE
- At the bottom: zero PE, maximum KE
      """,
      additionalContent:
          "In real systems, some energy converts to heat due to friction, but total energy is still conserved.",
    ),
    LessonSection(
      content: """
Other forms of energy:
- Thermal energy (heat)
- Chemical energy (food, fuel)
- Electrical energy
- Nuclear energy
 
All forms can be converted between each other, but the total always stays the same.
      """,
      message: "Energy never disappears — it just changes form!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "A \$3\,\\mathrm{kg}\$ ball moves at \$6\,\\mathrm{m/s}\$. What is its kinetic energy?",
      type: QuestionType.typing,
      answer: "\$54\$",
      hint: "KE = 1/2 × m × v². Don't forget to square the velocity.",
    ),
    QuizProblem(
      question:
          "True or False: In a frictionless system, the total mechanical energy remains constant.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "This is the Law of Conservation of Mechanical Energy.",
    ),
    QuizProblem(
      question:
          "As a roller coaster descends from its highest point, what energy conversion occurs?",
      type: QuestionType.multipleChoice,
      options: ["KE → PE", "PE → KE", "Thermal → KE", "KE → Thermal"],
      answer: "PE → KE",
      hint: "Height (PE) decreases; speed (KE) increases.",
    ),
  ],
);

final powerLesson = Lesson(
  title: "Power",
  description: "Understand power as the rate of doing work over time.",
  sections: [
    LessonSection(
      content: """
Power is the rate at which work is done, or energy is transferred.

Formula:
\$P = \\frac{W}{t}\$

Where:
- \$P\$ = power (Watts, W)
- \$W\$ = work done (Joules, J)
- \$t\$ = time (seconds, s)

Equivalently: \$P = F \\cdot v\$ (force times velocity)
      """,
      message:
          "Two workers doing the same job — the faster one uses more power!",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.chartExperiment,
          title: "Power vs. Time",
          prompt:
              "100 J of work is done. Decrease the time and watch how power increases.",
          valueLabel: "Time",
          valueUnit: " s",
          minValue: 1,
          maxValue: 10,
          initialValue: 5,
          targetMin: 1,
          targetMax: 3,
          outputLabel: "Power (W)",
          outputMultiplier: 20,
          revealOnComplete:
              "Exactly. Less time for the same work means greater power output.",
        ),
      ],
    ),
    LessonSection(
      content: """
The SI unit of power is the Watt (W):
\$1\,\\mathrm{W} = 1\,\\mathrm{J/s}\$

Another common unit is horsepower (hp):
\$1\,\\mathrm{hp} \\approx 746\,\\mathrm{W}\$
      """,
      additionalContent:
          "Kilowatts (kW) and megawatts (MW) are used for larger power values like engines and power plants.",
    ),
    LessonSection(
      content: """
Examples of power in real life:
- A 60 W light bulb uses 60 J of energy every second.
- A car engine rated at 100 kW can do 100,000 J of work per second.
- A human climbing stairs at a moderate pace outputs about 100–200 W.
      """,
      message: "Power tells you how quickly energy gets used or transferred.",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "A machine does \$500\,\\mathrm{J}\$ of work in \$10\,\\mathrm{s}\$. What is its power?",
      type: QuestionType.typing,
      answer: "\$50\$",
      hint: "P = W / t.",
    ),
    QuizProblem(
      question: "True or False: 1 Watt equals 1 Joule per second.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "That is the definition of a Watt.",
    ),
    QuizProblem(
      question: "Which formula also correctly expresses power?",
      type: QuestionType.multipleChoice,
      options: ["\$P=Fv\$", "\$P=ma\$", "\$P=\\frac{F}{t}\$", "\$P=mv\$"],
      answer: "\$P=Fv\$",
      hint: "Power = force × velocity when force is constant.",
    ),
  ],
);

final momentumLesson = Lesson(
  title: "Momentum",
  description:
      "Learn about linear momentum and the law of conservation of momentum.",
  sections: [
    LessonSection(
      content: """
Momentum is the product of an object's mass and velocity. It is a vector quantity — it has both magnitude and direction.

Formula:
\$p = mv\$

Where:
- \$p\$ = momentum (kg·m/s)
- \$m\$ = mass (kg)
- \$v\$ = velocity (m/s)

A heavier or faster object has more momentum.
      """,
      message: "Momentum = how hard it is to stop a moving object.",
      interactions: [
        LessonInteraction(
          type: LessonInteractionType.sliderExperiment,
          title: "Momentum Explorer",
          prompt:
              "Keep velocity at 5 m/s. Increase the mass and observe how momentum grows.",
          valueLabel: "Mass",
          valueUnit: " kg",
          minValue: 1,
          maxValue: 10,
          initialValue: 1,
          targetMin: 5,
          targetMax: 9,
          outputLabel: "Momentum (kg·m/s)",
          outputMultiplier: 5,
          revealOnComplete:
              "Good. Momentum scales linearly with mass — double the mass, double the momentum.",
        ),
      ],
    ),
    LessonSection(
      content: """
Law of Conservation of Momentum:
In a closed system with no external forces, the total momentum before an event equals the total momentum after.

\$p_{before} = p_{after}\$
\$m_1 v_{1i} + m_2 v_{2i} = m_1 v_{1f} + m_2 v_{2f}\$

This applies to collisions, explosions, and all interactions.
      """,
      additionalContent:
          "Conservation of momentum is one of the most powerful tools in solving collision problems.",
    ),
    LessonSection(
      content: """
Momentum and Newton's Second Law are connected:

\$F = ma = m\\frac{\\Delta v}{\\Delta t} = \\frac{\\Delta p}{\\Delta t}\$

Force equals the rate of change of momentum. This is actually how Newton originally stated his second law.
      """,
      message: "Force doesn't just create acceleration — it changes momentum!",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "A \$5\,\\mathrm{kg}\$ object moves at \$3\,\\mathrm{m/s}\$. What is its momentum?",
      type: QuestionType.typing,
      answer: "\$15\$",
      hint: "p = m × v.",
    ),
    QuizProblem(
      question:
          "True or False: In a closed system, total momentum is conserved even during a collision.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "Conservation of momentum holds as long as no external force acts.",
    ),
    QuizProblem(
      question: "Which of the following has the greatest momentum?",
      type: QuestionType.multipleChoice,
      options: [
        "\$2\,\\mathrm{kg}\$ at \$10\,\\mathrm{m/s}\$",
        "\$5\,\\mathrm{kg}\$ at \$3\,\\mathrm{m/s}\$",
        "\$10\,\\mathrm{kg}\$ at \$1\,\\mathrm{m/s}\$",
        "\$1\,\\mathrm{kg}\$ at \$20\,\\mathrm{m/s}\$",
      ],
      answer: "\$2\,\\mathrm{kg}\$ at \$10\,\\mathrm{m/s}\$",
      hint:
          "Calculate p = mv for each: 20, 15, 10, 20. The first and last tie — pick the first listed.",
    ),
  ],
);

final physicsLessons = [
  mechanicsLesson,
  newtonFirstLawLesson,
  newtonSecondLawLesson,
  newtonThirdLawLesson,
  torqueLesson,
  workLesson,
  energyLesson,
  powerLesson,
  momentumLesson,
];
