% ------------------------------------------------------------------------------
% Function : plot dataset trajectory
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function dataset_plot_body_trajectory(body)

NSensor = length(body.sensor);
SubsampleFactor = 100;

q_RS_ = zeros(4, 0);
p_RS_R_ = zeros(3, 0);

% obtain trajectory from position or pose sensor
NTrajectory = 0;
for iSensor = 1:NSensor
  sensor = body.sensor{iSensor};
  if(strcmp(sensor.sensor_type, 'visual-inertial'))
    q_RS_ = body.sensor{iSensor}.data.q_RS;
    p_RS_R_ = body.sensor{iSensor}.data.p_RS_R;
    NTrajectory = size(p_RS_R_, 2);
  end
end

if(NTrajectory > 0)
  q_plotPose(p_RS_R_(:, 1), q_RS_(:, 1), '', 0.5);
  for i=SubsampleFactor+1:SubsampleFactor:NTrajectory
    q_plotPose(p_RS_R_(:, i), q_RS_(:, i), '', 0.05);
  end
  plot3(p_RS_R_(1, :), p_RS_R_(2, :), p_RS_R_(3, :), 'k');
end

axis equal;
grid on;

end
