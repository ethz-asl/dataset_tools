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
  
  % plot body (sensor configuration)
  figure();
  dataset_plot_body(dataset.body{iBody});
  title('sensor setup');
  
  % plot trajectory, including sensor configuration
  figure();
  dataset_plot_body_trajectory(dataset.body{iBody});
  title('body trajectory');
  
  % plot gyroscope and accelerometer measurements
  dataset_plot_inertial_sensor_measurements(dataset.body{iBody});
  
  % plot target observations
  dataset_plot_target_observations(dataset.body{iBody});
end

disp(' ');

end
