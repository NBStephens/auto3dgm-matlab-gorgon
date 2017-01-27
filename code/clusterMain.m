% Executes cluster analysis from single script

touch('./cluster');
touch('./cluster/output');
touch('./cluster/error');
touch('./cluster/script');

funcArg = {'clusterMapLowRes', 'clusterReduceLowRes', 'clusterMapHighRes', 'clusterReduceLowRes'};

PBS = '#PBS -l nodes=1:ppn=1,walltime=3:00:00\n#PBS -m abe\n';
command = 'matlab -nodesktop -nodisplay -nojvm -nosplash -r ';
matlab_call = @(n) ['\"' funcArg{n} '; exit;\"'];

qsub = '!qsub ';
holdArg = {'', '-hold_jid clusterMapLowRes, job*', '-hold_jid clusterReduceLowRes', '-hold_jid clusterMapHighRes, job*'};
etcArg = @(n) ['-N ' funcArg{n} ' -o ./cluster/output/stdout_' funcArg{n} ' -e ./cluster/error/stderr_' funcArg{n} ' ./cluster/script/script_' funcArg{n}]; 

for i = 1:length(funcArg)
	% Create script
	txt = [PBS command matlab_call(i)];
	fid = fopen(['./cluster/script/script_', funcArg{i}], 'w');
	fprintf(fid, txt);
	fclose(fid);

	% Evaluate qsub with script
	qsub_call = [qsub holdArg{i} etcArg(i)];
	disp(qsub_call);
	%eval(qsub_call);
end

% sequence of qsub calls

% clusterMapLowRes
% !qsub -N clusterMapLowRes -o ./cluster/output/stdout_clusterMapLowRes -e ./cluster/error/stderr_clusterMapLowRes ./cluster/scripts/script_clusterMapLowRes
% script_clusterMapLowRes:
% #PBS -l nodes=1:ppn=1,walltime=3:00:00\n#PBS -m abe\n
% matlab -nodesktop -nodisplay -nojvm -nosplash -r "clusterMapLowRes; exit;"

% clusterReduceLowRes
% !qsub -N clusterReduceLowRes -hold_jid clusterMapLowRes, job* -o ./cluster/output/stdout_clusterReduceLowRes -e ./cluster/error/stderr_clusterReduceLowRes ./cluster/scripts/script_clusterReduceLowRes
% script_clusterReduceLowRes:
% #PBS -l nodes=1:ppn=1,walltime=3:00:00\n#PBS -m abe\n
% matlab -nodesktop -nodisplay -nojvm -nosplash -r "clusterReduceLowRes; exit;"

% clusterMapHighRes
% !qsub -N clusterMapHighRes -hold_jid clusterReduceLowRes -o ./cluster/output/stdout_clusterMapHighRes -e ./cluster/error/stderr_clusterMapHighRes ./cluster/scripts/script_clusterMapHighRes
% script_clusterMapHighRes:
% #PBS -l nodes=1:ppn=1,walltime=3:00:00\n#PBS -m abe\n
% matlab -nodesktop -nodisplay -nojvm -nosplash -r "clusterMapHighRes; exit;"

% clusterReduceHighRes
% !qsub -N clusterReduceHighRes -hold_jid clusterMapHighRes, job* -o ./cluster/output/stdout_clusterReduceHighRes -e ./cluster/error/stderr_clusterReduceHighRes ./cluster/scripts/script_clusterReduceHighRes
% script_clusterReduceHighRes:
% #PBS -l nodes=1:ppn=1,walltime=3:00:00\n#PBS -m abe\n
% matlab -nodesktop -nodisplay -nojvm -nosplash -r "clusterReduceHighRes; exit;"