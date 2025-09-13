<!-- Description: Estimate time and projects with PERT.-->

tags: misc

# Estimate time and projects with PERT

The Program Evaluation and Review Technique (PERT) is a project management tool
that applies statistical methods to analyze and visualize the tasks required to
complete a project. By incorporating three time estimates—optimistic, most likely,
and pessimistic -- it provides a more accurate forecast of task durations, enabling
more effective planning and scheduling.

There is a longer and much more complex definition of PERT, check 
[Wikipedia](https://en.wikipedia.org/wiki/Program_evaluation_and_review_technique).
Here is a very simple and pragmatic description of it and how I use it.

If there is a task with unknown time. 

<math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
  <mrow>
    <mi>T</mi>
    <mo>=</mo>
    <mfrac>
      <mrow>
        <mi>P</mi>
        <mo>+</mo>
        <mn>4</mn>
        <mi>N</mi>
        <mo>+</mo>
        <mi>O</mi>
      </mrow>
      <mn>6</mn>
    </mfrac>
  </mrow>
</math>

- **T** time to complete
- **P** the most pessimistic time;
- **N** nominal time the most realistic time;
- **P** the most optimistic time;

Of course, this is a not silver bullet, but might be very useful in the most of cases.