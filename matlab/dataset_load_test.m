% ------------------------------------------------------------------------------
% Function : Load Dataset Test Script
% Project  :
% Author   : www.asl.ethz.ch
% Version  : V01  07JUL2015 Initial version.
% Comment  :
% Status   : 
% ------------------------------------------------------------------------------

clc;
close all;

% set dataset folder
datasetPath = ...
  '~/nas_mapbox/Datasets/Euroc-Datasets/ijrr_dataset_paper/machine_hall/01_easy';

disp(' ');
disp([' > dataset_load_test [', datasetPath, ']']);
disp(' ');

% load dataset
dataset = dataset_load(datasetPath);

% plot dataset
dataset_plot(dataset);
