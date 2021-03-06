function app = gui_get_reactants(varargin)
    % Get the species and the number of moles of the current data in
    % UITable_R
    obj = varargin{1,1};
    event = varargin{1,2};
    app = varargin{1,3};
    if nargin > 3
        FLAG_COMPUTE_FROM_PHI = varargin{1,4};
    else
        FLAG_COMPUTE_FROM_PHI = false;
    end
    % Get indexes of the different type of species in the mixture
    obj = gui_get_typeSpecies(obj);
    % Get species in the mixture
    species = obj.UITable_R.Data(:, 1);
    % Get number of moles of each species in the mixture
    moles = gui_get_moles(obj, event, app, FLAG_COMPUTE_FROM_PHI);
    % Get temperature of the species in the mixture
    temperatures = obj.UITable_R.Data(:, 5);
    % Set mixture into variable app
    app = gui_set_species_moles_temperatures(obj, app, species, moles, temperatures, 'S_Fuel', 'N_Fuel', 'T_Fuel', 'ind_Fuel');
    app = gui_set_species_moles_temperatures(obj, app, species, moles, temperatures, 'S_Oxidizer', 'N_Oxidizer', 'T_Oxidizer', 'ind_Oxidizer');
    app = gui_set_species_moles_temperatures(obj, app, species, moles, temperatures, 'S_Inert', 'N_Inert', 'T_Inert', 'ind_Inert');
    % Compute ratio oxidizers/O2
    app = compute_ratio_oxidizers_O2(app);
end

% SUB-PASS FUNCTIONS
function obj = gui_get_typeSpecies(obj)
    % Function that obtains the indexes of the different type of species in
    % the mixture
    typeSpecies = obj.UITable_R.Data(:, 4);
    obj.ind_Fuel     = contains(typeSpecies, 'Fuel');
    obj.ind_Oxidizer = contains(typeSpecies, 'Oxidizer');
    obj.ind_Inert    = contains(typeSpecies, 'Inert');
end

function app = gui_set_species(obj, app, species, species_name, ind_name)
    % Get the species of the current data in
    % UITable_R for a given category (Fuel, Oxidizer, Inert)
    app.PD.(species_name) = species(obj.(ind_name))';
end

function app = gui_set_species_moles_temperatures(obj, app, species, moles, temperatures, species_name, moles_name, temperatures_name, ind_name)
    % Get the species and the number of moles and the temperatures of the 
    % current data in UITable_R for a given category (Fuel, Oxidizer, Inert)

    % Set species
    app = gui_set_species(obj, app, species, species_name, ind_name);
    
    % Set moles
    try
        app.PD.(moles_name) = cell2vector(moles(obj.(ind_name)));
    catch 
        app.PD.(moles_name) = [];
    end
    
    % Set temperatures
    try
        if ~app.Misc.FLAGS_PROP.TR
            app.PD.(temperatures_name) = cell2vector(temperatures(obj.(ind_name)));
        else
            app.PD.(temperatures_name) = [];
        end
    catch 
        app.PD.(temperatures_name) = [];
    end
end

function moles = gui_get_moles(obj, event, app, FLAG_COMPUTE_FROM_PHI)
    % Get number of moles of each species in the mixture
    if FLAG_COMPUTE_FROM_PHI
        % Set equivalence ratio
        app.PD.phi.value = gui_get_prop(app, 'phi', obj.edit_phi.Value, 'direction', 'first');
        % Get proportion of inert_O2
        obj.PD.ratio_oxidizers_O2 = gui_ratio_oxidizers_O2(obj);
        % compute moles from equivalence ratio
        moles = gui_compute_moles_from_equivalence_ratio(obj, app);
    else
        try
            if event.Indices(1, 2) ~= 3 
                moles = obj.UITable_R.Data(:, 2);
            else 
                % compute moles from mole fractions
                 moles = gui_compute_moles_from_molar_fractions(obj);
            end
        catch
             moles = gui_compute_moles_from_molar_fractions(obj);
        end
    end
end

function moles = gui_compute_moles_from_molar_fractions(obj)
    % Compute moles from mole fractions
    total_moles = sum(cell2vector(obj.UITable_R.Data(:, 2)));
    mole_fractions = cell2vector(obj.UITable_R.Data(:, 3));
    moles = mole_fractions * total_moles;
    if isnan(moles)
        moles = zeros(1, length(mole_fractions));
    end
end

function moles = gui_compute_moles_from_equivalence_ratio(obj, app)
    % Compute moles from equivalence ratio (phi)
    
    if any(obj.ind_Fuel)
        species = obj.UITable_R.Data(:, 1);
        moles = obj.UITable_R.Data(:, 2);
        temperatures = obj.UITable_R.Data(:, 5);
        app = gui_set_species_moles_temperatures(obj, app, species, moles, temperatures, 'S_Fuel', 'N_Fuel', 'T_Fuel', 'ind_Fuel');
        app = gui_set_species_moles_temperatures(obj, app, species, moles, temperatures, 'S_Oxidizer', 'N_Oxidizer', 'T_Oxidizer', 'ind_Oxidizer');
        app = gui_compute_propReactants(obj, app);
    end
    if any(obj.ind_Oxidizer)
        moles = assign_vector2cell(moles, app.PD.phi_t/app.PD.phi.value(1) .* obj.PD.ratio_oxidizers_O2, obj.ind_Oxidizer);
    end
    if any(obj.ind_Inert)
        moles = assign_vector2cell(moles, obj.UITable_R.Data(obj.ind_Inert, 2), obj.ind_Inert);
    end
end

function ratio_oxidizers_O2 = gui_ratio_oxidizers_O2(obj)
    % Get proportion of inert_O2
    temp_app = [];
    FLAG_IDEAL_AIR = obj.IdealAirCheckBox.Value;
    if ~isempty(find_ind(obj.UITable_R.Data(:, 1), 'O2'))
        temp_app = set_air(temp_app, FLAG_IDEAL_AIR);
        ratio_oxidizers_O2 = temp_app.PD.ratio_oxidizers_O2;
    else
        ratio_oxidizers_O2 = 1;
    end
end