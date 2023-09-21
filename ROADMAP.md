1.  Hardcoded circuit visualisation
    
    * Allow to:

    1. Save the output as a .png image;
    2. Visualise the output image on screen;
    3. Save a text file representation of the circuit configured in canonical form (optional).

    -- correctness tests: hardcode 3 circuits with increasing levels of complexity.


2. Interactive input

   * Receive input from commandline.
   
   * Implement the Julia ";" convention to re-compute the plot only when ";" is missing.

   Corner cases, guaranteed by tests:
    - different components with the same name will produce an error;
    - a negative value for resistance, capacity etc will produce an error;
    - a non numeric value for resistance, capacity etc will produce an error;
    - a zero value for resistance, capacity, etc will produce a warning.

    -- correctness tests: give in input 3 circuits from commandline with increasing levels of complexity.


3. Accept input from file (read as interactive input)
   
    * Raise a warning for input file without ";".
   
   Corner cases, guaranteed by tests:
   - different components with the same name will produce an error;
   - a negative value for resistance, capacity etc will produce an error;
   - a non numeric value for resistance, capacity etc will produce an error;
   - a zero value for resistance, capacity, etc will produce a warning.

   -- correctness tests: give in input 3 circuits from files with increasing levels of complexity.

   3.1. Accept various kinds of formats as input files

   -- correctness tests: give in input 3 circuits from each format with increasing levels of complexity.


4. Modify existing circuits
   
   * Either from commandline and from file allow to:
   1. Add components;
   2. Remove components;
   3. Modify components.

   Corner cases, guaranteed by tests:
   - removing a non-existing component will produce an error;
   - modifying a non-existing component will produce an error;
   - modifying valid values of an existing component with invalid values will produce an error.

   -- correctness tests: modify 3 circuits in different ways.


5. Allow to define new kind components (optional)

    * Each new kind of components is defined by a name, an image and a set of parameters (with the relative physical units) chosen by the user.  

   Corner cases, guaranteed by tests:
   - defining a component kind without a kind name will produce an error;
   - defining a component kind without a image will produce an error;
   - defining a component kind with zero parameters will produce a warning;
   - defining a component kind with the same kind name of a component kind already defined will produce an error;
   - defining a component kind with the same image of a component kind already defined will produce a warning;
   - defining a component kind with the same set of parameters of a component already defined will produce a warning.

   -- correctness tests (1): check that 3 different new component kinds correctly defined will produce the correct canonical form of the circuit.

   -- correctness tests (2): check that 3 different new component kinds correctly defined will produce the correct output.

   5.1. Allow to define components with multiple wires as inputs or outputs

   Corner cases, guaranteed by tests:
   - defining a component without an input wire will produce a warning;
   - defining a component without an output wire will produce a warning.
   
   -- correctness tests: check the canonical form and the output of a component with multiple inputs, of a component with multiple outputs and of a component with multiple inputs and multiple outputs.
