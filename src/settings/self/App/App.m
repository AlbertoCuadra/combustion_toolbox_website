function app = App(varargin)
    % Function that create a struct called app with all the data needed
    try
        [app, LS, FLAG_FAST] = initialize(varargin);
        app.E = Elements();
        app.S = Species();
        app.C = Constants();
        app.Misc = Miscellaneous();
        app.PD = ProblemDescription();
        app.PS = ProblemSolution();
        app.TN = TunningProperties();
        app = constructor(app, LS, FLAG_FAST);
        if ~nargin || ~isa(varargin{1,1}, 'combustion_toolbox_app') || ~isa(varargin{1,1}, 'combustion_toolbox_app_old') || ~isa(varargin{1,1}, 'combustion_toolbox_app_original') || (~strcmpi(varargin{1,1}, 'fast') && nargin < 4) 
            app = Initialize(app);
        end
    catch ME
      errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
      ME.stack(1).name, ME.stack(1).line, ME.message);
      fprintf('%s\n', errorMessage);
      uiwait(warndlg(errorMessage));
    end
end

function [app, LS, FLAG_FAST] = initialize(varargin)
    varargin = varargin{1,1};
    nargin = length(varargin); % If varargin is empty, by default nargin will return 1, not 0.
    app = struct();
    LS = [];
    FLAG_FAST = false;
    if nargin
        if strcmpi(varargin{1,1}, 'fast')
            FLAG_FAST = true;
            app.DB_master = varargin{1,2};
            app.DB = varargin{1,3};
            if nargin == 4
                LS = varargin{1,4};
            end
            return
        end
        if isa(varargin{1,1}, 'combustion_toolbox_app') || isa(varargin{1,1}, 'combustion_toolbox_app_old') || isa(varargin{1,1}, 'combustion_toolbox_app_original')
            app = varargin{1,1};
            if nargin == 2
                LS = varargin{1,2};
            end
        else
            LS = varargin{1,1};
        end
    end
end

function app = constructor(app, LS, FLAG_FAST)
    % FLAG_GUI
    app = check_GUI(app);
    % Set Database
    reducedDB = false;
    app = set_DB(app, reducedDB, FLAG_FAST);
    % Set ListSpecies
    if ~isempty(LS)
        app = ListSpecies(app, LS);
    else
        app = ListSpecies(app);
    end
    % Set Contained elements
    app = ContainedElements(app);
    % Timer
    app.Misc.timer_0 = tic;
end

function app = check_GUI(app)
    if isa(app, 'combustion_toolbox_app') || isa(app, 'combustion_toolbox_app_old') || isa(app, 'combustion_toolbox_app_original')
        app.Misc.FLAG_GUI = true;
    end
end