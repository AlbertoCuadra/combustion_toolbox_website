function self = ListSpecies(varargin)
% Specify List of Species

if ~isempty(varargin{1,1})
    self = varargin{1,1};
    FLAG = false;
else
    self = struct();
    FLAG = true;
end

if nargin < 2
    LS = 'SOOT FORMATION';
else
    if iscell(varargin{1,2})
        self.S.LS = varargin{1,2};
    else
        LS = varargin(2);
    end
end

if exist('LS', 'var')
    if contains(LS, 'COMPLETE', 'IgnoreCase', true) 
        self.S.FLAG_COMPLETE = true;
        if nargin > 2
            EquivalenceRatio = varargin{1, 3};
            EquivalenceRatio_soot = varargin{1, 4};
            if EquivalenceRatio < 1
                self.S.LS = self.S.LS_lean;
            elseif EquivalenceRatio >= 1 && EquivalenceRatio < EquivalenceRatio_soot
                self.S.LS = self.S.LS_rich;
            else
                self.S.LS = self.S.LS_soot;
            end
        else
            self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar', 'Cbgrb'};
        end
    elseif strcmpi(LS, 'HC/O2/N2 EXTENDED')
        self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar',...
                    'OH','H','O','HO2','NO','HCO','CH4','CH3',...
                    'NO2','NH3','NH2','N','HCN','CN','N2O','C2','CH'};
                
    elseif strcmpi(LS, 'HC/O2/N2')
        self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar'};
        
    elseif strcmpi(LS, 'HC/O2/N2 RICH')
        self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar',...
                    'HCN','H','OH','O','CN','NH3','CH4','C2H4','CH3',...
                    'NO','HCO','NH2','NH','N','CH'};
                
    elseif strcmpi(LS, 'SOOT FORMATION')
        self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar',...
                    'HCN','H','OH','O','CN','NH3','CH4','C2H4','CH3',...
                    'NO','HCO','NH2','NH','N','CH','Cbgrb'};
                
    elseif strcmpi(LS, 'SOOT FORMATION EXTENDED')
        self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar',...
                    'H', 'O', 'OH', 'HO2', 'H2O2',...
                    'CH', 'CH2', 'CH3', 'CH4', 'HCO',...
                    'CH2OH', 'CH3O', 'CH3OH', 'C2H', 'C2H4',...
                    'C2H5', 'C2H6', 'HCCO', 'N', 'NH', 'NH2', 'NH3',...
                    'NO', 'NO2', 'N2O', 'HNO', 'CN', 'HCN',...
                    'NCO', 'C3H8','C2','C2H2_acetylene','C6H6',...
                    'C8H18_isooctane','C2H5OH','HNC','HNCO','NH2OH',...
                    'COOH','CH2CO_ketene','OCCN','C2N2','C2O','Cbgrb',...
                    'HCHO_formaldehy','C3H4_allene','C3H4_propyne','CH3CHO_ethanal',...
                    'CH3CN','C3H6_propylene','HCOOH','CH3COOH','C3H6O_acetone'};
                
    elseif strcmpi(LS, 'NASA ALL')
        self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar',...
                    'CH3','CH4','CN','CO2','C2H','CH2CO_ketene',...
                    'C2H3_vinyl','C2H4','CH3COOH','C2H6','CH3OCH3','CNC','C2O',...
                    'C3H3_2_propynl','C3H6O_propanal',...
                    'C3H8','CNCOCN','C4H2_butadiyne','C4H6_1butyne','C4H8_1_butene',...
                    'C4H8_isobutene','C4H9_n_butyl','C4H9_t_butyl','C4N2',...
                    'C5H11_pentyl','C5H12_i_pentane','C6H5_phenyl','C6H5OH_phenol',...
                    'C7H7_benzyl','C7H14_1_heptene','C7H16_2_methylh',...
                    'C8H16_1_octene','C8H18_isooctane','C10H21_n_decyl','H','HCCN','HNCO',...
                    'HNO3','HCHO_formaldehy','H2O2','NCO','NH3','NO2','N2O','NH2NO2','N2O4',...
                    'N3H','O2','C2H5OHbLb','C6H6bLb','H2ObLb','CH','CH2OH','CH3OH',...
                    'CNN','COOH','C2H2_acetylene','ObCHb2O','CH3CN','C2H4O_ethylen_o',...
                    'OHCH2COOH','CH3N2CH3','CH3O2CH3','OCCN','C3','C3H4_allene','C3H5_allyl',...
                    'C3H6O_propylox','C3H7_n_propyl','C3H8O_1propanol','C3O2',...
                    'C4H6_2butyne','C4H8_cis2_buten',...
                    'C4H9_i_butyl','C4H10_n_butane','C5','C5H10_1_pentene','C5H11_t_pentyl',...
                    'CH3CbCH3b2CH3','C6H5O_phenoxy','C6H13_n_hexyl','C7H8',...
                    'C7H15_n_heptyl','C8H8_styrene','C8H17_n_octyl','C9H19_n_nonyl','C12H9_o_bipheny',...
                    'HCN','HCCO','HNO','HO2','HCOOH','NH','NH2OH','NO3','NCN','N2H4',...
                    'N2O5','O','O3','N2H4bLb','CH2',...
                    'CH3O','CH3OOH','C2','C2H2_vinylidene','HObCOb2OH','CH3CO_acetyl',...
                    'CH3CHO_ethanal','C2H5','C2H5OH','CCN','C2N2','C3H3_1_propynl','C3H4_propyne',...
                    'C3H6_propylene','C3H6O_acetone','C3H7_i_propyl','C3H8O_2propanol',...
                    'C4','C4H6_butadiene','C4H8_tr2_butene',...
                    'C4H9_s_butyl','C4H10_isobutane',...
                    'C5H12_n_pentane','C6H2','C6H6','C6H12_1_hexene','C6H14_n_hexane',...
                    'C7H8O_cresol_mx','C7H16_n_heptane','C8H10_ethylbenz','C8H18_n_octane',...
                    'C10H8_naphthale','C12H10_biphenyl','HCO','HNC','HNO2',...
                    'N','NH2','NO','N2H2','N2O3','N3','OH','CH3OHbLb','C6H5NH2bLb','C'};
                
    elseif strcmpi(LS, 'AIR') | strcmpi(LS, 'DISSOCIATED AIR')
        self.S.LS = {'O2','N2','O','O3','N','NO','NO2','NO3','N2O','N2O3','N2O4','N3','C','CO','CO2',...
                    'Ar','H2O','H2','H','He'};
        
    elseif strcmpi(LS, 'AIR_IONS') | strcmpi(LS, 'AIR IONS')
        self.S.LS = {'O2','N2','O','O3','N','NO','NO2','NO3','N2O','N2O3','N2O4','N3', ...
                     'eminus', 'Nminus', 'Nplus', 'NOplus', 'NO2minus', 'NO3minus', ...
                     'N2plus', 'N2minus', 'N2Oplus', 'Oplus', 'Ominus', 'O2plus', 'O2minus',...
                     'CO2','CO','COplus','C','Cplus','Cminus','CN','CNplus','CNminus','CNN',...
                     'NCO','NCN','Ar','Arplus','CO2plus','C2','C2plus','C2minus','CCN',...
                     'CNC','OCCN','C2N2','C2O','C3'};
    
    elseif strcmpi(LS, 'IDEAL_AIR') | strcmpi(LS, 'AIR_IDEAL')
        self.S.LS = {'O2','N2','O','O3','N','NO','NO2','NO3','N2O','N2O3','N2O4','N3'};
        
    elseif strcmpi(LS, 'HYDROGEN')
        self.S.LS = {'H','HNO','HNO3','H2O','NH','NH2OH','NO3','N2H2','N2O3','N3','OH','HNO2',...
                    'H2','N','NH3','NO2','N2O','N2H4','N2O5','O','O3','O2','N2','HO2','NH2','H2O2',...
                    'N3H','NH2NO2'};
    
    elseif strcmpi(LS, 'HYDROGEN_IONS')
    self.S.LS = {'H','HNO','HNO3','H2O','NH','NH2OH','NO3','N2H2','N2O3','N3','OH','HNO2',...
                'H2','N','NH3','NO2','N2O','N2H4','N2O5','O','O3','O2','N2','HO2','NH2','H2O2',...
                'N3H','NH2NO2', 'eminus', 'Nminus', 'Nplus', 'NOplus', 'NO2minus', 'NO3minus', ...
                'N2plus', 'N2minus', 'N2Oplus', 'Oplus', 'Ominus', 'O2plus', 'O2minus', ...
                'Hplus', 'Hminus', 'HO2minus', 'H2plus', 'H2minus', 'H2Oplus', 'H3Oplus'};
    
    elseif strcmpi(LS, 'HYDROGEN_L') | strcmpi(LS, 'HYDROGEN (L)')
        self.S.LS = {'H','H2O','OH','H2','O','O3','O2','HO2','H2O2','H2bLb','O2bLb'};
        
    elseif strcmpi(LS, 'HC/O2/N2 PROPELLANTS')
        self.S.LS = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2', 'He', 'Ar',...
                    'OH','H','O','HO2','NO','HCO','CH4','CH3',...
                    'NO2','NH3','NH2','N','HCN','CN','N2O','C2','CH',...
                    'H2bLb','O2bLb','RP_1'};
    else
        self.S.LS = LS;
    end
end

self.S.LS = unique(self.S.LS, 'stable');

if FLAG
    self = self.S.LS;
    return
end

self.S.NS = length(self.S.LS);
self.S.LS_formula = get_formula(self.S.LS, self.DB);

if any(get_index_ions(self.S.LS))
    self.PD.ionization = true;
end
end

% SUB-PASS FUNCTIONS
function LS_formula = get_formula(LS, DB)
    for i=length(LS):-1:1
        LS_formula{i} = DB.(LS{i}).txFormula;
    end
end