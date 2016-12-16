function X = get_subsampled_shape( dir , id , N ) 
% Read already subsampled file, if it exists
% If it doesnt or it does not have enough points, read original off file, subsample, save the subsampled file, and return subsample
% Arguments:
%   dir: path to file
%   id: shape number
%   N: number of subsampled points

sub_off_fn = fullfile(dir, 'subsampled', [num2str(id), '.off']);
off_fn     = fullfile(dir, 'original', [num2str(id), '.off']);

if exist( sub_off_fn , 'file' )
    [X, ~]       = read_off( sub_off_fn );
    n_subsampled_pts = size(X, 2);
else
    X                = [];
    n_subsampled_pts = 0;
end

if n_subsampled_pts < N
    [V, ~] = read_off( off_fn ); 
    ind   = subsample( V , N, X);
    X     = V ( :, ind );
    if ~exist(fullfile(dir, 'subsampled'), 'dir')
        mkdir(fullfile(dir, 'subsampled'));
    end
    write_off( sub_off_fn, X, [1 2 3]'); %write_off breaks if there are no faces
end

end
