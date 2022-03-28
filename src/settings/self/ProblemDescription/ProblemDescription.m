function self = ProblemDescription()
    self.description = "Problem description";
    self.CompleteOrIncomplete = "incomplete";
    self.ProblemType = 'TP'; % Initialization for GUI
    self.R_Fuel = [];
    self.R_Oxidizer = [];
    self.R_Inert = [];
    self.phi.description = "Equivalence ratio";
    self.phi.value = 1.0;
    self.phi.t = 1.0; % Theoretical value: phi = phi_t / phi.st
    self.phi_t = [];
    self.Fuel.x = []; % C atoms in the fuel mixture
    self.Fuel.y = []; % H atoms in the fuel mixture
    self.Fuel.z = []; % O atoms in the fuel mixture
    self.Fuel.w = []; % N atoms in the fuel mixture
    self.Fuel.eps = 0.;
    self.TR.description = "Temperature of reactants";
    self.TR.value = []; % [K]
    self.pR.description = "Pressure of reactants";
    self.pR.value = []; % [bar]
    self.TP.description = "Temperature of products";
    self.TP.value = []; % [K]
    self.pP.description = "Pressure of products";
    self.pP.value = []; % [bar]
    self.proportion_inerts_O2 = [];
    self.vP_vR.description = "Volume relation Products/Reactants";
    self.vP_vR.value = []; % [-]
    self.u1.description = "Incident shock velocity";
    self.u1.value = []; % [m/s]
    self.overdriven.description = "Overdriven shock velocity";
    self.overdriven.value = []; % [-]
    self.theta.description = "Deflection angle - oblique shocks";
    self.theta.value = [];
    self.beta.description = "Wave angle - oblique shocks";
    self.beta.value = [];
    self.S_Fuel = [];
    self.N_Fuel = [];
    self.T_Fuel = [];
    self.S_Oxidizer = [];
    self.N_Oxidizer = [];
    self.T_Oxidizer = [];
    self.S_Inert = [];
    self.N_Inert = [];
    self.T_Inert = [];
    self.ionization = false;
end