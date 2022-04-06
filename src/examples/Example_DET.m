% -------------------------------------------------------------------------
% EXAMPLE: DET
%
% Compute pre-shock and post-shock state for a planar detonation
% considering Chapman-Jouguet (CJ) theory for lean to rich CH4-air mixtures
% at standard conditions, a set of 26 species considered and a set of
% equivalence ratios (phi) contained in (0.5, 5) [-]
%   
%   
% Soot formation == {'CO2','CO','H2O','H2','O2','N2','He','Ar','Cbgrb',...
%                    'C2','C2H4','CH','CH','CH3','CH4','CN','H',...
%                    'HCN','HCO','N','NH','NH2','NH3','NO','O','OH'}
%   
% See wiki or ListSpecies() for more predefined sets of species
%
% @author: Alberto Cuadra Lara
%          PhD Candidate - Group Fluid Mechanics
%          Universidad Carlos III de Madrid
%                 
% Last update Oct 22 2021
% -------------------------------------------------------------------------

%% INITIALIZE
self = App('Soot Formation');
%% INITIAL CONDITIONS
self = set_prop(self, 'TR', 300, 'pR', 1 * 1.01325, 'phi', 0.5:0.01:4);
self.PD.S_Fuel     = {'CH4'};
self.PD.S_Oxidizer = {'O2'};
self.PD.S_Inert    = {'N2', 'Ar', 'CO2'};
self.PD.proportion_inerts_O2 = [78.084, 0.9365, 0.0319] ./ 20.9476;
%% ADDITIONAL INPUTS (DEPENDS OF THE PROBLEM SELECTED)
% No additional data required. The initial velocity is unique for CJ
% condition
%% SOLVE PROBLEM
self = SolveProblem(self, 'DET');
%% DISPLAY RESULTS (PLOTS)
postResults(self);