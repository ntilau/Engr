function [EigenVector] = getEigvecDepFreq(eigNumb, freq, dirStr, projStr)
% Get Eigenvectors for a set of frequencies





system(['cd ' dirStr projStr ' & EM_eigenmodesolver2d '  projStr ' ' ...
     num2str(freq, '%g') ' ' num2str(eigNumb) ' +SingleLevelCoupling writeMatrices +pg +o \w' ]   );

vectorName1 = [dirStr projStr '\' projStr '.2D_3D'];
[evVectorAVP1, EVMatrixAVP1 ] = evSolutionReader( vectorName1 ) ;
 
EigenVector = EVMatrixAVP1 ;

%  
% for n = 1:eigNumb,
%   EigenVector(:,n) = vectorReader([dirStr projStr '\eig_' num2str(n-1)]);
% end
