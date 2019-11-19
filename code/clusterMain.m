% Executes cluster analysis from single script

jadd_path;

touch(fullfile(pwd, '/cluster'));
touch(fullfile(pwd, '/cluster/output'));
touch(fullfile(pwd, '/cluster/error'));
touch(fullfile(pwd, '/cluster/script'));

delete(fullfile(pwd, '/cluster/output/*'));
delete(fullfile(pwd, '/cluster/error/*'));
delete(fullfile(pwd, '/cluster/script/*'));

PBS = '#PBS -A tmr21_b_g_sc_default -l nodes=1:ppn=1 -l mem=100gb -l walltime=48:00:00\n#PBS -m abe\n';
modules = 'module load gcc/7.3.1 mkl/11.3.3 tbb/4.4.4 python/3.6.3-anaconda5.0.1 matlab/R2017b\n';
command = 'matlab -nodesktop -nodisplay -nosplash -r ';
matlab_call = ['\"cd ' pwd '; clusterRun; exit;\"'];

if (length(strfind(email_notification, '@')) == 1)
    qsub_call = ['!qsub -A tmr21_b_g_sc_default -m e -M ' email_notification ' -N clusterRun -o ' fullfile(pwd, '/cluster/output/stdout_clusterRun') ' -e ' fullfile(pwd, '/cluster/error/stderr_clusterRun') ' ' fullfile(pwd, '/cluster/script/script_clusterRun')]; 
else
    qsub_call = ['!qsub -A tmr21_b_g_sc_default -N clusterRun -o ' fullfile(pwd, '/cluster/output/stdout_clusterRun') ' -e ' fullfile(pwd, '/cluster/error/stderr_clusterRun') ' ' fullfile(pwd, '/cluster/script/script_clusterRun')]; 
end

txt = [PBS modules command matlab_call];
fid = fopen(fullfile(pwd, '/cluster/script/script_clusterRun'), 'w');
fprintf(fid, txt);
fclose(fid);

% Evaluate qsub with script
disp(qsub_call);
eval(qsub_call);
