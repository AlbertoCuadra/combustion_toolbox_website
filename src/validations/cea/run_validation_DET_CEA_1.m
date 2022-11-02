function problems_solved = run_validation_DET_CEA_1
    % Run test validation_DET_CEA_1:
    % Contrasted with: NASA's Chemical Equilibrium with Applications software
    % Problem type: Chapman-Jouguet Detonation
    % Temperature [K]   = 300;
    % Pressure    [bar] = 1;
    % Equivalence ratio [-] = 0.5:0.01:4
    % Initial mixture: C2H2_acetylene + AIR_IDEAL (79% N2 + 21% O2)
    % List of species considered: list_species('Soot Formation Extended')
    
    % Inputs
    Fuel = 'C2H2_acetylene';
    prefixDataName = 'C2H2';
    filename = {strcat(prefixDataName, '_air1_detonations.out'), strcat(prefixDataName, '_air1_detonations2.out'), strcat(prefixDataName, '_air1_detonations3.out')};

    LS =  'Soot Formation Extended';
    display_species = {'CO2', 'CO', 'H2O', 'H2', 'O2', 'N2',...
                      'HCN','H','OH','O','CN','NH3','CH4','C2H4','CH3',...
                      'NO','HCO','NH2','NH','N','CH','Cbgrb'};
    tolN = 1e-18;
    % Combustion Toolbox
    results_CT = run_CT('ProblemType', 'DET',...
                        'Species', LS,...
                        'S_Fuel', Fuel,...
                        'EquivalenceRatio', 0.5:0.01:4,...
                        'tolN', tolN);
    problems_solved = length(results_CT.PD.range);
    % Load results CEA 
    results_CEA = data_CEA(filename, display_species);
    % Display validation (plot)
    % * Molar fractions
    [~, fig1] = plot_molar_fractions(results_CT, results_CT.PS.strR, 'phi', 'Xi', 'y_var', results_CT.PS.strP, 'validation', results_CEA, 'display_species', display_species);
    % * Properties mixture 2 - 1
    fig2 = plot_properties_validation(results_CT, results_CEA, {'phi', 'phi', 'phi', 'phi', 'phi', 'phi', 'phi', 'phi'}, {'T', 'p', 'rho', 'h', 'e', 'g', 'S', 'gamma_s'}, 'mix2');
    % * Properties mixture 2 - 2
    fig3 = plot_properties_validation(results_CT, results_CEA, {'phi', 'phi', 'phi', 'phi', 'phi', 'phi', 'phi', 'phi'}, {'cP', 'cV', 'gamma_s', 'dVdT_p', 'dVdp_T', 'sound', 'W', 'u_preshock'}, 'mix2');
    % Save plots
    folderpath = strcat(pwd,'\Validations\Figures\');
    stack_trace = dbstack;
    filename = stack_trace.name;
    saveas(fig1, strcat(folderpath, filename, '_molar'), 'svg');
    saveas(fig2, strcat(folderpath, filename, '_properties_1'), 'svg');
    saveas(fig3, strcat(folderpath, filename, '_properties_2'), 'svg');
end