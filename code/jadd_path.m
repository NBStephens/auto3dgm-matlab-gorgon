%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% NO NEED TO MODIFY ANYTHING OTHER THAN THIS FILE!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% setup parameters in this section 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% "meshesPath" is where the orignal meshes are located
meshesPath = '/gpfs/group/LiberalArts/default/tmr21_collab/RyanLab/Projects/For_Adam_G/auto3dgm/femur';


%%%%% "outputPath" stores intermediate files, re-aligned meshes, and
%%%%% morphologika files
outputPath = '/gpfs/group/LiberalArts/default/tmr21_collab/RyanLab/Projects/For_Adam_G/auto3dgm/femur_results_3';

%%%%% set parameters for the algorithm
restart = 1;
iniNumPts = 600; %The amount of psuedolandmarks used for the initial alignment.
finNumPts = 1200; %The amount of psuedolandmarks used to the high resolution alignment.
allow_reflection = 1; %%%%% A 1 allows for mirroring the bone, a 0 does not. 
max_iter = 3000; %The number of iterations before ceasing the pairwise alignment.
use_cluster = 1; %A 1 means you will be using the cluster, which is what you want with a large dataset.
n_jobs = 50; %%% more nodes, more failure (no hadoop!) hadoop is an older parallel processing library, which you do want to have run.
email_notification = ''; %If you want email notifications for job ending, fill this portion out. It can be a lot of emails, though. This has been modified to only email on abort.

%%%%% experimental parameters
align_to = 'auto'; %Presumably set this to align to a specific bone. 
do_tangent_pca = 1;
do_procrustes_dist_output = 1;

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

