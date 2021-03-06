# Tutorial

With this short tutorial you will familiarize with the basic functionalities of Combustion Toolbox

## Getting Started 
Start MATLAB and browse for folder where you have downloaded Combustion Toolbox. To include files in `PATH` run this command in the command window: 
```matlab
>> addpath(genpath(pwd))
```
First, using Combustion Toolbox, you have to initialize the tool (load databases, set default variables, ...). To do that at the prompt type:
```matlab
>> self = App
```
If files contained in Combustion Toolbox are correctly defined, you should see something like this:
```matlab
self = 

  struct with fields:

            E: [1×1 struct]
            S: [1×1 struct]
            C: [1×1 struct]
         Misc: [1×1 struct]
           PD: [1×1 struct]
           PS: [1×1 struct]
           TN: [1×1 struct]
    DB_master: [1×1 struct]
           DB: [1×1 struct]
```
## Setting the state
Indicate temperature [K] and pressure [bar] of the initial mixture
 ```matlab
>> self = set_prop(self, 'TR', 300, 'pR', 1 * 1.01325);
```
Indicate species and number of moles of each species in the initial mixture
### Individual case
For example, for a stochiometric CH4-ideal_air mixture:
```matlab
>> self.PD.S_Fuel     = {'CH4'};
>> self.PD.N_Fuel     = 1;
>> self.PD.S_Oxidizer = {'N2', 'O2'};
>> self.PD.N_Oxidizer = [7.52, 2];
```
This is the same as specifying a unit value for the equivalence ratio:
```matlab
>> self.PD.S_Fuel     = {'CH4'};
>> self.PD.S_Oxidizer = {'N2', 'O2'};
>> self.PD.ratio_oxidizers_O2 = [79, 21]/21;
>> self = set_prop(self, 'phi', 1);
```
The last two lines of code establish the proportion of the oxidizers species over O$_2$ and the equivalence ratio, respectively. The number of moles are calculated considering that the number of moles of fuel is one by default.
### Several cases
Combustion Toolbox also allows the computation of a range of values of different properties. For example, in case we want to compute a range of values of the equivalence ratio, e.g., phi = 0.5:0.01:5, do this:
```matlab
>> self.PD.S_Fuel     = {'CH4'};
>> self.PD.S_Oxidizer = {'N2', 'O2'};
>> self.PD.ratio_oxidizers_O2 = [79, 21]/21;
>> self = set_prop(self, 'phi', 0.5:0.01:5);
```
## Chemical Equilibrium

Depending on the problem you want to solve, you may need to configure additional inputs. For example, to compute the equilibrium composition at a defined temperature and pressure (TP) we have to set these values as
```matlab
>> self = set_prop(self, 'pP', self.PD.pR.value, 'TP', 3000);
```
and to solve the aforementioned problem, run
```matlab
>> self = SolveProblem(self, 'TP');
```
The results are contained in `self.PS`. By default, this routine print the results through the command window (default: self.Misc.FLAG_RESULTS=true) which gives for the stoichiometric case (phi=1):
```matlab
COMPUTING Nº MOLES FROM EQUIVALENCE RATIO (PHI).
***********************************************************
-----------------------------------------------------------
Problem type: TP  | phi = 1.0000
-----------------------------------------------------------
               |    REACTANTS    |      PRODUCTS
T [K]          |       300.0000  |      3000.0000
p [bar]        |         1.0132  |         1.0132
r [kg/m3]      |         1.1225  |         0.1029
h [kJ/kg]      |      -254.5296  |      2574.2795
e [kJ/kg]      |      -344.7953  |      1589.5140
g [kJ/kg]      |     -2428.4002  |    -30246.9221
s [kJ/(kg-K)]  |         7.2462  |        10.9404
W [g/mol]      |        27.6333  |        25.3293
(dlV/dlp)T [-] |                 |        -1.0285
(dlV/dlT)p [-] |                 |         1.5830
cp [kJ/(kg-K)] |         1.0786  |         5.5609
gamma [-]      |         1.3869  |         1.1357
sound vel [m/s]|       353.8198  |      1057.5349
-----------------------------------------------------------
REACTANTS               Xi [-]
N2                   7.1493e-01
O2                   1.9005e-01
CH4                  9.5023e-02
MINORS[+22]          0.0000e+00

TOTAL                1.0000e+00
-----------------------------------------------------------
PRODUCTS                Xi [-]
N2                   6.4771e-01
H2O                  1.1162e-01
CO                   5.8485e-02
OH                   3.5936e-02
H2                   3.0822e-02
CO2                  2.8615e-02
H                    2.7583e-02
O2                   2.5914e-02
O                    1.8096e-02
NO                   1.5206e-02
N                    1.1123e-05
NH                   9.5805e-07
HCO                  1.2464e-07
NH2                  1.1860e-07
NH3                  3.0265e-08
HCN                  4.4103e-09
CN                   4.0110e-10
CH                   5.7109e-13
CH3                  1.5595e-13
CH4                  1.1358e-14
MINORS[+5]           9.0496e-19

TOTAL                1.0000e+00
------------------------------------------------------------------------
************************************************************************
```
## Postprocessed results (predefined plots for several cases)
There are some predefined charts based on the selected problem, in case you have calculated multiple cases. Just calling the routine
```matlab
>> postResults(self);
```
will reproduce **Figure 1** which represents the variation of the molar fraction with the equivalence ratio for lean to rich CH4-ideal_air mixtures at 3000 [K] and 1.01325 [bar]. 

<p align="center">
    <img src="_static/img/Tutorial_1.svg" width="1000">
</p>

**Figure 1:** *Example TP: variation of molar fraction for lean to rich CH4-ideal_air mixtures at 3000 [K] and 1.01325 [bar], a set of 26 species considered and a total of 451 case studies. The computational time was of 3.04 seconds using a Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz.*

## Congratulations!
Congratulations you have finished the Combustion Toolbox Matlab tutorial! You should now be ready to begin using Combustion Toolbox on your own.