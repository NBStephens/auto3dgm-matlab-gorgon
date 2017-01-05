function coordR = coord_axis_rotation(vertexArray)
% COORD_AXIS_ROTATION - Return rotation matrix to orient PCAs to coordinate axes
% For a collection of centered scaled aligned surface meshes, derives principal axes of shape 
% variation and calculates rotation matrix to align first, second, and third 
% principal axes with Y, X, and Z coordinate axes respectively. Applying 
% rotation matrix to surface meshes orients surfaces so that principal axes of 
% shape variation correspond to coordinate axes, providing a semi-standardized 
% orientation in 3D space. 
%
% Syntax: coordR = coord_axis_rotation(ds, ga)
%
% Inputs:
%	ds - Structure array of surface shape data (see clusterMapLowRes.m)
%   ga - Structure array of alignment data (see clusterMapLowRes.m, globalize.m)
% 			   	
% Outputs:
% 	coordR - 3x3 rotation matrix aligning PCAs to coordinate axes

% Author: Julie Winchester, Ph.D.
% Department of Evolutionary Anthropology, Duke University
% Email: jmw110@duke.edu
% Website: http://www.apotropa.com
% January 5, 2017

vertex = cell2mat(vertexArray);
% vertex = [];
% for ii = 1 : length(meshArray)
% 	vertex = [vertex meshArray{ii}.V];
% end

w = pca(vertex');
pcVector = center(w);
axisVector = center([0, 1, 0; 1, 0, 0; 0, 0, 1]');
covariance = pcVector * axisVector';
[svdU, ~, svdV] = svd(covariance);
coordR = svdV * svdU';

if det(coordR) < 0
	coordR = [coordR(:,1:2), -coordR(:,3)];
end