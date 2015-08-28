% ------------------------------------------------------------------------------
% Function : Plot ASL Dataset
% Project  : ASL Datasets
% Author   : ASL, ETH
% Version  : V01  07JUL2015 Initial version.
% Comment  :
% Status   : 
% ------------------------------------------------------------------------------


function dataset_plot(dataset)

disp(' >> plotting bodys');
NBody = length(dataset.body);
for iBody = 1:NBody
  figure();
  dataset_plot_body(dataset.body{iBody});
  axis equal;
end

disp(' ');

end
