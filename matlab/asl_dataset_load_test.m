% ------------------------------------------------------------------------------
% Function : Load ASL Dataset Test Script
% Project  :
% Author   : ASL, ETH
% Version  : V01  07JUL2015 Initial version.
% Comment  :
% Status   : 
% ------------------------------------------------------------------------------


% set dataset folder
datasetPath = ...
  '~/nas_mapbox/Datasets/Euroc-Datasets/asl_dataset_format/datasets/machine_hall_01';

disp(' ');
disp([' > asl_dataset_load_test [', datasetPath, ']']);
disp(' ');

% load dataset
dataset = asl_dataset_load(datasetPath);

% plot dataset
asl_dataset_plot(dataset);
