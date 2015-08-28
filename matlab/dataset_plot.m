% ------------------------------------------------------------------------------
% Function : plot dataset
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
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
