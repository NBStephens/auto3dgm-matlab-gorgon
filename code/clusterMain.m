% Executes cluster analysis from single script

PBS = '#PBS -l nodes=1:ppn=1,walltime=3:00:00\n#PBS -m abe\n';
command = 'matlab -nodesktop -nodisplay -nojvm -nosplash -r ';
matlab_call = {'clusterMapLowRes', 'clusterReduceLowRes', 'clusterMapHighRes', 'clusterReduceLowRes'};
sub_sh = @(n) ['!qsub -N ' matlab_call{n} ' -o ./cluster/stdout_' matlab_call{n} ' -e ./cluster/stderr_' matlab_call{n} ' '] 