% -------------------------------------------------------------------------
% EXAMPLE: SHOCK_I_IONIZATION
%
% Compute pre-shock and post-shock state for a planar incident shock wave
% at standard conditions, a set of 39 species considered and a set of
% initial shock front velocities (u1) contained in (360, 13000) [m/s]
%    
% Air_ions == {'O2','N2','O','O3','N','NO','NO2','NO3','N2O','N2O3',...
%              'N2O4','N3','eminus','Nminus','Nplus','NOplus','NO2minus',...
%              'NO3minus','N2plus','N2minus','N2Oplus','Oplus','Ominus',...
%              'O2plus', 'O2minus','CO2','CO','COplus','C','Cplus',...
%              'Cminus','CN','CNplus','CNminus','CNN','NCO','NCN','Ar',...
%              'Arplus'}
%   
% See wiki or ListSpecies() for more predefined sets of species
%
% @author: Alberto Cuadra Lara
%          PhD Candidate - Group Fluid Mechanics
%          Universidad Carlos III de Madrid
%                 
% Last update July 22 2022
% -------------------------------------------------------------------------

% Air_ions = {'O2','N2','O','O3','N','NO','NO2','NO3','N2O','N2O3',...
%              'N2O4','N3_M','eminus','Nminus','Nplus','NOplus','NO2minus_M',...
%              'NO3minus_M','N2plus','N2minus','N2Oplus','Oplus','Ominus',...
%              'O2plus', 'O2minus','CO2','CO','COplus','C','Cplus',...
%              'Cminus','CN_M','CNplus_M','CNminus_M','CNN_M','NCO','NCN_M','Ar',...
%              'Arplus','O2_M','O3_M','CO2_M','O3minus_M','O3plus_M',...
%              'N3minus_M','N3plus_M','NO3plus_M','CNminus_M','CNplus_M',...
%              'NCOminus_M','NCOplus_M','NCNminus_M','NCNplus_M','O4_M',...
%              'O4minus_M','O4plus_M'};

Air_ions = {'O2','N2','O','O3','N','NO','NO2','NO3','N2O','N2O3',...
             'N2O4','N3','eminus','Nminus','Nplus','NOplus','NO2minus',... 
             'NO3minus','N2plus','N2minus','N2Oplus','Oplus','Ominus',...
             'O2plus', 'O2minus','CO2','CO','COplus','C','Cplus',...
             'Cminus','CN','CNplus','CNminus','CNN','NCO','NCN','Ar',...
             'Arplus'};

% Air_ions = find_species_LS(LS, {'C','N','O','minus','plus','Ar'}, 'any',...
% {'I', 'S', 'L', 'T', 'P', 'F', 'ab', 'W', 'Z','X','R','Os','Cr','H','Br',...
% 'G','K','U','Co','Cu','B','V','Ni','Na','Mg','Mo','Ag','Nb','Cb','Cl','D','T',...
% 'Ca','Cs','Ne','Cd','Mn'}, 'all');

%% INITIALIZE
self = App(Air_ions);
%% INITIAL CONDITIONS
self = set_prop(self, 'TR', 300, 'pR', 1 * 1.01325);
self.PD.S_Oxidizer = {'N2', 'O2', 'Ar', 'CO2'};
self.PD.N_Oxidizer = [78.084, 20.9476, 0.9365, 0.0319] ./ 20.9476;
%% ADDITIONAL INPUTS (DEPENDS OF THE PROBLEM SELECTED)
u1 = logspace(2, 5, 500); u1 = u1(u1<20000); u1 = u1(u1>=347.25);
self = set_prop(self, 'u1', u1);
%% SOLVE PROBLEM
self = SolveProblem(self, 'SHOCK_I');
%% DISPLAY RESULTS (PLOTS)
postResults(self);