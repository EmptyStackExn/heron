Heron
===================

> Symbolic Simulation Engine for Timed Causality Models expressed in the [Tagged Events Specification Language (TESL)](http://wwwdi.supelec.fr/software/TESL/)

[![Build Status](https://travis-ci.org/EmptyStackExn/heron.svg?branch=master)](https://travis-ci.org/EmptyStackExn/heron)

This prototype solves specifications in TESL [1] by **structure-directed counterfactual reasoning**. Unlike the original solver, Heron [2] does not focus on execution and returns classes of execution traces. They allow to identify and isolate events (*aka* clocks) that may be **interfering** with others.

Getting started
-------------------
We recommend compiling with [MLton](http://mlton.org/) to enjoy the interesting code optimization features of Standard ML. To build sources, type the following
```bash
sudo apt-get install mlton ml-lex ml-yacc
make
```

Several examples are provided in `examples` directory. To solve one of them, you can simply type
```bash
./heron < examples/basic/ImplicationsTimeScales.tesl
```

Example
-------------------
Let's try to solve this specification
```
int-clock master1 sporadic 1, 4, 7
int-clock master2 sporadic   2, 5
unit-clock slave
tag relation master1 = master2

master1 implies slave
master2 implies slave
```

The TESL tagged event engine will produce the following run:
![Example 3, TESL Official Website](http://wwwdi.supelec.fr/software/downloads/TESL/example3.svg)

Our tool uses counterfactual reasoning on the purely-syntactic structure of TESL-formulae to derive disjunction cases. Such execution branches are iteratively abstracted as constraints in **Horn-style Affine Arithmetic**. Along the simulation, inconsistent branches are filtered out by an embedded decision procedure.

By default, the solver stops whenever a **finite satisfying run class** is found. The simulation of the above example converges at the 5th step and returns 32 possible behaviors.
```
### Solver has successfully returned 32 models
## Simulation result:
		m1		m2		slave		
[1]		⇑ 1		⊘		⇑
[2]		⊘		⇑ 2		⇑
[3]		⇑ 4		⊘		⇑
[4]		⊘		⇑ 5		⇑
[5]		⇑ 7		⊘		⇑
## End
...
```

References
-------------------

 1. [TESL: a Language for Reconciling Heterogeneous Execution Traces](https://ieeexplore.ieee.org/document/6961849), Formal Methods and Models for Codesign (MEMOCODE), 2014 Twelfth ACM/IEEE International Conference on, Lausanne, Switzerland, Oct, 2014, 114-123
 2. The project is named after [Heron of Alexandria](http://www-history.mcs.st-andrews.ac.uk/Biographies/Heron.html), the first-century Greek mathematician and engineer.

License
-------------------

Heron is release under the MIT License.

THE PROVIDER MAKES NO REPRESENTATIONS ABOUT THE SUITABILITY, USE, OR PERFORMANCE OF THIS SOFTWARE OR ABOUT ANY CONTENT OR INFORMATION MADE ACCESSIBLE BY THE SOFTWARE, FOR ANY PURPOSE. THE SOFTWARE IS PROVIDED "AS IS," WITHOUT EXPRESS OR IMPLIED WARRANTIES INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NONINFRINGEMENT WITH RESPECT TO THE SOFTWARE. THE PROVIDER IS NOT OBLIGATED TO SUPPORT OR ISSUE UPDATES TO THE SOFTWARE.

