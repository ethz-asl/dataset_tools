% ------------------------------------------------------------------------------
% Function : minimal load dataset test script
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

addpath('quaternion');

% set dataset folder
datasetPath = ...
  '~/nas_mapbox/Datasets/Euroc-Datasets/ijrr_dataset_paper/vicon_room1/01_easy';

disp(' ');
disp([' > dataset_load_test [', datasetPath, ']']);

assert(exist(datasetPath, 'dir') > 0, ...
  ' > Dataset folder does not exist, Please set datasetPath.');

% load dataset
dataset = dataset_load(datasetPath);

% plot dataset
dataset_plot(dataset);
