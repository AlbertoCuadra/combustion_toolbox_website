function [mix2_inj, mix2_c, mix3] = compute_chamber_FAC(self, mix1, varargin)
    % Compute chemical equilibria at the injector, outlet of the chamber,
    % using the Finite-Area-Chamber (FAC) model
    %
    % This method is based on Gordon, S., & McBride, B. J. (1994). NASA reference publication, 1311.
    %
    % Args:
    %     self (struct): Data of the mixture, conditions, and databases
    %     mix1 (struct): Properties of the initial mixture
    %     mix2_inj (struct): Properties of the mixture at the injector of the chamber (previous calculation)
    %     mix2_c (struct): Properties of the mixture at the outlet of the chamber (previous calculation)
    %
    % Returns:
    %     mix2_inj (struct): Properties of the mixture at the injector of the chamber
    %     mix2_c (struct): Properties of the mixture at the outlet of the chamber
    %     mix3 (struct): Properties of the mixture at the throat
    
    % Abbreviations
    TN = self.TN;
    % Unpack 
    if nargin > 3, mix2_inj = get_struct(varargin{1}); else, mix2_inj = []; end
    if nargin > 4, mix2_c = get_struct(varargin{2}); else, mix2_c = []; end
    if nargin > 5, mix3 = get_struct(varargin{3}); else, mix3 = []; end
    % Definitions
    Aratio_chamber = self.PD.Aratio_c.value;
    % Obtain mixture compostion and properties at the injector of the chamber (equivalent to the outlet of the chamber using IAC model)
    mix2_inj = compute_chamber_IAC(self, mix1, mix2_inj);
    % Get results
    pressure_inj = pressure(mix2_inj); % [bar]
    % Compute guess pressure_inf
    pressure_inf = compute_initial_guess_pressure(pressure_inj, Aratio_chamber); % [bar]
    % Initialization
    STOP = 1; it = 0;
    mix2_inf = [];
    pressure_inj = pressure_inj * 1e5; % [Pa]
    % Loop
    while STOP > TN.tol_rocket && it < TN.it_rocket
        it = it + 1;
        % Get guess
        mix1.p = pressure_inf; % [bar]
        % Obtain mixture compostions
        [mix2_inf, mix3, mix2_c] = compute_IAC_model(self, mix1, mix2_inf, mix3, mix2_c, Aratio_chamber);
        % Get results
        pressure_c = pressure(mix2_c) * 1e5; % [Pa]
        density_c = density(mix2_c); % [kg/m3]
        velocity_c = velocity_relative(mix2_c); % [m/s]
        % Compute pressuse_inj_a
        pressure_inj_a = (pressure_c + density_c * velocity_c^2); % [Pa]
        % Check convergence
        STOP = abs(pressure_inj - pressure_inj_a) / pressure_inj;
        % Update guess
        pressure_inf = pressure_inf * pressure_inj / pressure_inj_a; % [bar]
        mix2_inf.p = pressure_inf;
        % Debug
%         aux_lambda(it) = pressure_inj / pressure_inj_a;
%         aux_STOP(it) = STOP;
    end
%     debug_plot_error(it, aux_STOP, aux_lambda);
    % Assign values
    mix2_c.Aratio = Aratio_chamber; % [-]
end

% SUB-PASS FUNCTIONS
function str = get_struct(var)
    try
        str = var{1,1};
    catch
        str = var;
    end
end

function pressure_inf = compute_initial_guess_pressure(pressure_inj, Aratio_chamber)
    % Compute initial guess of the pressure assuming an Infinite-Area-Chamber
    % (IAC) for the Finite-Area-Chamber model (FAC)
    pressure_inf = pressure_inj * (1.0257 - 1.2318 * Aratio_chamber) / (1 - 1.26505 * Aratio_chamber);
end

function [mix2_inf, mix3, mix2_c] = compute_IAC_model(self, mix1, mix2_inf, mix3, mix2_c, Aratio)
    % Solve IAC model
    self.PD.FLAG_IAC = true;
    self.PD.FLAG_SUBSONIC = true;
    mix2_inj = [];
    [~, mix2_inf, mix3, mix2_c] = solve_model_rocket(self, mix1, mix2_inj, mix2_inf, mix3, mix2_c, Aratio);
end