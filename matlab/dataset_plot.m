% ------------------------------------------------------------------------------
% Function : Plot ASL Dataset
% Project  : ASL Datasets
% Author   : ASL, ETH
% Version  : V01  07JUL2015 Initial version.
% Comment  :
% Status   : 
% ------------------------------------------------------------------------------


function asl_dataset_plot(dataset)

addpath('~/git/tools/matlab_tools/quaternion');

disp(' >> plotting bodys');
NBody = length(dataset.body);
for iBody = 1:NBody
  figure();
  asl_dataset_plot_body(dataset.body{iBody});
  axis equal;
end

disp(' ');

end
