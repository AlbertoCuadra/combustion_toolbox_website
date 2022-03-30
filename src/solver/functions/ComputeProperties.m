function mix =  ComputeProperties(self, SpeciesMatrix, p, T)
    % Compute properties from the given SpeciesMatrix at pressure p [bar] 
    % and temperature T [K]
    %
    % Args:
    %     self (struct):         Data of the mixture, conditions, and databases
    %     SpeciesMatrix (float): Matrix with the stoichiometric and properties values of the mixture
    %     p (float):             pressure [bar]
    %     T (float):             Temperature [K]
    %
    % Returns:
    %     self (struct):         Data of the mixture, conditions, and databases
    
    R0 = self.C.R0; % [J/(K mol)]. Universal gas constant
    mix.NatomE = sum(SpeciesMatrix(:, 1) .* self.C.A0.value);
    
    if isempty(self.E.ind_C), mix.x = 0; else, mix.x = mix.NatomE(self.E.ind_C); end
    if isempty(self.E.ind_H), mix.y = 0; else, mix.y = mix.NatomE(self.E.ind_H); end
    if isempty(self.E.ind_O), mix.z = 0; else, mix.z = mix.NatomE(self.E.ind_O); end
    if isempty(self.E.ind_N), mix.w = 0; else, mix.w = mix.NatomE(self.E.ind_N); end
    
    mix.N       = sum(SpeciesMatrix(:, 1)); % [mol] 
    mix.hf      = sum(SpeciesMatrix(:,2));  % [kJ]
    mix.DhT     = sum(SpeciesMatrix(:,3));  % [kJ]
    mix.h       = mix.hf + mix.DhT;         % [kJ]
    mix.ef      = sum(SpeciesMatrix(:,4));  % [kJ]
    mix.DeT     = sum(SpeciesMatrix(:,5));  % [kJ]
    mix.e       = mix.ef + mix.DeT;         % [kJ]
    mix.cP      = sum(SpeciesMatrix(:,6));  % [J/K]     
    mix.cV      = sum(SpeciesMatrix(:,7));  % [J/K]   
    mix.pv      = sum(SpeciesMatrix(:,9));  % [bar m3]
    mix.p       = p;                        % [bar]
    mix.v       = mix.pv / mix.p;           % [m3]
    mix.swtCond = SpeciesMatrix(:,10);      % [bool]
    mix.mi      = sum(SpeciesMatrix(:,11)); % [kg]
    mix.rho     = mix.mi / mix.v;           % [kg/m3]
    
    mix.Yi      = SpeciesMatrix(:,11)./mix.mi; % [-]
    mix.W       = 1/sum(mix.Yi./SpeciesMatrix(:,12),'OmitNan');
    
    Ni          = SpeciesMatrix(:,1); % [mol]
    mix.Xi      = Ni/mix.N;           % [-]
    ii          = mix.Xi>0;     
    mix.S0      = sum(SpeciesMatrix(:,8)); % [kJ/K]
    DSi         = Ni(ii).*log(mix.Xi(ii)*p).*(1-mix.swtCond(ii)); % only nonzero for noncondensed species
    mix.DS      = -R0*sum(DSi) * 1e-3; % [kJ/K]
    mix.S       = (mix.S0 + mix.DS); % [kJ/K]
    mix.T       = T; % [K]
    mix.g       = mix.h - mix.T * mix.S; % [kJ]
    mix.e       = mix.h - sum(Ni(ii) .* (1 - mix.swtCond(ii))) * R0 * T *1e-3; % [kJ]
    mix.gamma   = mix.cP/mix.cV; % [-]
    mix.sound   = sqrt(mix.gamma * p * 1e5 / mix.rho); % [m/s]
    
    % Correction of: cP, cV, gamma and speed of sound as consequence of the
    % chemical reaction
    if isfield(self, 'dNi_T')
        mix.dVdT_p =  1 + self.dN_T; % [-]
        mix.dVdp_T = -1 + self.dN_p; % [-]
        mix.gamma_s = - mix.gamma / mix.dVdp_T; % [-]
        if ~any(isnan(self.dNi_T)) && ~any(isinf(self.dNi_T))
            ind = SpeciesMatrix(:, 1) > 0;
            H0_j = (SpeciesMatrix(ind, 2) + SpeciesMatrix(ind, 3)) * 1e3; % [J]
            mix.cP_r = sum(H0_j/T .* self.dNi_T(ind) .* (1 - mix.swtCond(ind))) + sum(H0_j/T .* self.dNi_T(ind) .* mix.swtCond(ind) ./ Ni(ind)); % [J/K]
            mix.cP = mix.cP + mix.cP_r; % [J/K]
            mix.cV = mix.cP + (mix.pv/T * mix.dVdT_p^2) / mix.dVdp_T * 1e5; % [J/K]
            mix.gamma = mix.cP/mix.cV; % [-]
            mix.gamma_s = - mix.gamma / mix.dVdp_T; % [-]
            mix.sound = sqrt(mix.gamma_s*p*1e5/mix.rho); % [m/s]
        end
    else
        mix.gamma_s = mix.gamma;
    end
end
