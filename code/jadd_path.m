%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% NO NEED TO MODIFY ANYTHING OTHER THAN THIS FILE!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% setup parameters in this section 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% "meshesPath" is where the orignal meshes are located
meshesPath = '/gtmp/BoyerLab/Debug-Nov14-2016/data/';

%%%%% "outputPath" stores intermediate files, re-aligned meshes, and
%%%%% morphologika files
outputPath = '/gtmp/BoyerLab/Debug-Nov14-2016/output/';

%%%%% set parameters for the algorithm
restart = 1;
iniNumPts = 200;
finNumPts = 1000;
n_jobs = 100; %%% more nodes, more failure (no hadoop!)
use_cluster = 0;
allow_reflection = 1;
max_iter = 3000;
email_notification = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% do not modify anything beyond this point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
codePath= [fileparts(pwd) filesep];
path(pathdef);
path(path, genpath(fullfile(codePath, 'software', 'RectangularAssignment')));
path(path, genpath(fullfile(codePath, 'software', 'ToolboxGraph')));

if verLessThan('matlab', '7.9')
	warning(['Auto3dgm dependency Mosek does not support MATLAB versions ' ...
		'older than r2009b. Auto3dgm may crash.']);
	path(path, genpath(fullfile(codePath, 'software', 'mosek', '7', 'toolbox', 'r2009b')));
elseif verLessThan('matlab', '7.14')
	if ismac
		warning(['Auto3dgm dependency Mosek does not support OSX MATLAB ' ...
			'versions older than r2012a. Auto3dgm may crash.']);
    end
	path(path, genpath(fullfile(codePath, 'software', 'mosek', '7', 'toolbox', 'r2009b')));
elseif verLessThan('matlab', '8.1')
	path(path, genpath(fullfile(codePath, 'software', 'mosek', '7', 'toolbox', 'r2012a')));
else
	path(path, genpath(fullfile(codePath, 'software', 'mosek', '7', 'toolbox', 'r2013a')));
end

setenv('MOSEKLM_LICENSE_FILE', [codePath 'software/mosek/mosek.lic'])

