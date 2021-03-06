function obj = gui_CalculateButtonPushed(obj, event)
    % Solve selected problem, update GUI with the results and generate
    % predefined plots.
    try
        % Set lamp to Working color
        obj.Lamp.Color = obj.color_lamp_working;
        % Get List of Species considered (reactants + products)
        obj = get_listSpecies_gui(obj);
        % Initialize variable app
        app = App('fast', obj.DB_master, obj.DB, obj.LS);
        % Set FLAG GUI
        app.Misc.FLAG_GUI = true;
        % Get tolerances and tunning values
        app = get_tunning_values(obj, app);
        % Get initial conditions
        app = get_input_constrains(obj, app);
        app = gui_get_reactants(obj, event, app);
        % Update GUI terminal
        gui_update_terminal(obj, app, 'start');
        % Solve selected problem
        app = SolveProblem(app, app.PD.ProblemType);
        % Save results
        results = save_results(obj, app);
        % Update GUI with the last results of the set
        obj = gui_update_results(obj, results);
        % Update GUI terminal
        gui_update_terminal(obj, app, 'finish')
        % Display results (plots)
        postResults(app);
        % Set lamp to Done color
        obj.Lamp.Color = obj.color_lamp_done;
    catch ME
        % Set lamp to Error color
        obj.Lamp.Color = obj.color_lamp_error;
        % Print error
        message = {sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message)};
        uialert(obj.UIFigure, message, 'Warning', 'Icon', 'warning');
    end
end

% SUB-PASS FUNCTIONS
function app = get_tunning_values(obj, app)
    % Get tolerances and tunning values from GUI and set into app
    app.TN.tolN = obj.TraceoptionEditField.Value;
    app.TN.tol0 = obj.RootFindingMethodEditField.Value;
    app.TN.tol_shocks = obj.ShocksandDetonationsEditField.Value;
    app.C.mintol_display = obj.DisplaySpeciesEditField.Value;
    
    app.TN.itMax = obj.MaxiterationsRFMEditField.Value;
    app.TN.it_shocks = obj.MaxiterationsSDEditField.Value;
    app.TN.root_T0_l = obj.RFMT0_LEditField.Value;
    app.TN.root_T0_r = obj.RFMT0_REditField.Value;
    app.TN.root_T0 = obj.RFMT0EditField.Value;
end

function obj = gui_update_results(obj, results)
    % Update:
    %  1. GUI with the last results computed
    %  2. GUI-UITree with all the results
    
    % Update GUI with the last result computed
    gui_write_results(obj, results, 1);
    % Update UITree with all the results
    gui_add_nodes(obj.Node_Results, results)
end

function obj = get_listSpecies_gui(obj)
    obj.LS = obj.listbox_Products.Items;
    if isempty(obj.LS)
        % Get default value
        obj.LS = ListSpecies([], 'Soot Formation');
    end
end
function results = save_results(obj, app)
    % Save results
    N = length(app.PS.strR);
    
    if strcmpi(app.PD.ProblemType, 'ROCKET')
        label_mix1 = 'strR';
        label_mix2 = 'mix3';
    else
        label_mix1 = 'strR';
        label_mix2 = 'strP';
    end
    for i = N:-1:1
        results(i).mix1 = app.PS.(label_mix1){i};
        results(i).mix2 = app.PS.(label_mix2){i};
        results(i).ProblemType = app.PD.ProblemType;
        if ischar(obj.Reactants.Value)
            results(i).Reactants = '1';
        else
            results(i).Reactants = obj.Reactants.Items{sscanf(obj.Reactants.Value, '%d')};
        end
        results(i).Products = obj.Products.Value;
        if isempty(results(i).Products)
            results(i).Products = 'Default';   
        end
        results(i).LS = app.S.LS;
        results(i).LS_products = obj.LS;
        results(i).UITable_R_Data = obj.UITable_R.Data;
    end
end

function app = get_input_constrains(obj, app)
    % Get input constrains
    app.PD.ProblemType = obj.ProblemType.Value;
    app = set_prop(app, 'TR', obj.PR1.Value, 'pR', obj.PR2.Value, 'phi', obj.edit_phi.Value);
    switch app.PD.ProblemType
        case 'TP' % * TP: Equilibrium composition at defined T and p
            app = set_prop(app, 'TP', obj.PP1.Value, 'pP', obj.PP2.Value);
        case 'HP' % * HP: Adiabatic T and composition at constant p
            app = set_prop(app, 'pP', obj.PP2.Value);
        case 'SP' % * SP: Isentropic (i.e., adiabatic) compression/expansion to a specified p
            app = set_prop(app, 'pP', obj.PP2.Value);
        case 'TV' % * TV: Equilibrium composition at defined T and constant v
            app = set_prop(app, 'TP', obj.PP1.Value, 'pP', obj.PP2.Value);
        case 'EV' % * EV: Equilibrium composition at Adiabatic T and constant v
            app = set_prop(app, 'pP', obj.PP2.Value);
        case 'SV' % * SV: Isentropic (i.e., fast adiabatic) compression/expansion to a specified v
            app = set_prop(app, 'vP_vR', obj.PP4.Value);
        case 'SHOCK_I' % * SHOCK_I: CALCULATE PLANAR INCIDENT SHOCK WAVE
            app = set_prop(app, 'u1', obj.PR3.Value);
        case 'SHOCK_R' % * SHOCK_R: CALCULATE PLANAR POST-REFLECTED SHOCK STATE
            app = set_prop(app, 'u1', obj.PR3.Value);
        case {'DET', 'DET_R'} % * DET: CALCULATE CHAPMAN-JOUGUET STATE
            % No additional constrains
        case {'DET_OVERDRIVEN', 'DET_OVERDRIVEN_R'} % * DET_OVERDRIVEN: CALCULATE OVERDRIVEN DETONATION
            app = set_prop(app, 'overdriven', obj.PR3.Value);
        case {'ROCKET'} % * ROCKET: ROCKET PROPELLANT PERFORMANCE
            % Get model
            app.PD.FLAG_IAC = obj.FLAG_IAC.Value;
            if ~obj.FLAG_IAC.Value
                if ~isempty(obj.PP1.Value)
                    app = set_prop(app, 'Aratio_c', obj.PP1.Value);
                elseif ~isempty(obj.PP2.Value)
                    app = set_prop(app, 'mass_flux', obj.PP2.Value);
                else
                    % Set lamp to Error color
                    obj.Lamp.Color = obj.color_lamp_error;
                    % Print error
                    message = {'The FAC model needs an additional value! The contraction factor A_chamber/A_throat or the mass flux.'};
                    uialert(obj.UIFigure, message, 'Warning', 'Icon', 'warning');
                end
            end
            if ~isempty(obj.PR3.Value)
                app = set_prop(app, 'Aratio_subsonic', obj.PR3.Value);
            end
            if ~isempty(obj.PP3.Value)
                app = set_prop(app, 'Aratio_supersonic', obj.PP3.Value);
            end
    end
    if contains(obj.Products.Value, 'complete', 'IgnoreCase', true)
        app.S.FLAG_COMPLETE = true;
    end
end