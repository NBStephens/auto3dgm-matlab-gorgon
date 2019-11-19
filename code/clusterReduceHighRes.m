%% set path and preparation
jadd_path;

disp('Loading saved workspace...');
load(fullfile(outputPath, 'session_high.mat'));
disp('Loaded!');

pa = reduce( ds, pa, n_jobs );
%% Globalization
% mst is the same as before
ga     = globalize( pa, mst , ds.base );
ga.k   = k;

%% Output higher resolution
write_obj_aligned_shapes(ds, ga);
write_off_global_alignment( fullfile(ds.msc.output_dir, 'alignment_high.off'), ds , ga, 1:ds.n, 10, [cos(theta) -sin(theta) 0 ; sin(theta) cos(theta) 0; 0 0 1]*[ 0 0 1; 0 -1 0; 1 0 0]*ds.shape{1}.U_X{k}',3.0,1);
write_morphologika( fullfile(ds.msc.output_dir, 'morphologika_unscaled_high.txt'), ds, ga );

disp('Saving current workspace....');
system(['rm -rf ' fullfile(outputPath, 'session_high.mat')]);
save(fullfile(outputPath, 'session_high.mat'), '-v7.3');
disp('Saved!');

%% Compute all pairwise Procrustes distances
%k          = 3;
proc_d     = zeros( ds.n , ds.n );
for ii = 1 : ds.n
    for jj = ii : ds.n
        if( ii == jj )
            continue;
        end
        [tmpR, proc_d( ii, jj)] = jprocrustes( ds.shape{ii}.X{k}*ga.P{ii} , ds.shape{jj}.X{k}*ga.P{jj} );
    end
end
mst_proc_d = graphminspantree( sparse( proc_d + proc_d' ) );
proc_d = (proc_d+proc_d')/2;

if ds.n > 2
	plot_tree( proc_d , mst_proc_d , ds.names , 'mds', ones(1,ds.n) , 'MDS procrustes distances' );
	coords = mdscale(proc_d,3)';
	if size(coords,1) == 3
		write_off_placed_shapes( fullfile(ds.msc.output_dir,'map.off'), coords, ds, ga, eye(3), mst_proc_d);
	end
end

%% Optional outputting of procrustes distance matrix of rotated meshes
if do_procrustes_dist_output == 1
	names = matlab.lang.makeValidName(ds.names, 'ReplacementStyle', 'hex');
	d_table = array2table(proc_d, 'RowNames', names, 'VariableNames', names);
	writetable(d_table, fullfile(ds.msc.output_dir, 'proc_d.csv'));
end

%% Optional principal components analysis of partial procrustes tangent coordinates
if do_tangent_pca == 1
	tangent_pca(ds, ga, k);
end

disp('Alignment Completed');
