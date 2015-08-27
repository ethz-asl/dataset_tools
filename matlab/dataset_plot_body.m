% ------------------------------------------------------------------------------
% Function : Plot ASL Dataset Body
% Project  : ASL Datasets
% Author   : ASL, ETH
% Version  : V01  07JUL2015 Initial version.
% Comment  :
% Status   : 
% ------------------------------------------------------------------------------


function asl_dataset_plot_body(body)

addpath('~/git/tools/matlab_tools/quaternion');
addpath('~/git/tools/matlab_tools/quaternion/mex_functions');

NSensor = length(body.sensor);

% plot body
q_plotPose(zeros(3, 1), [0;0;0;1], body.name, 0.01);
hold on;

% plot sensors
for iSensor = 1:NSensor
  sensor = body.sensor{iSensor};
  p_BS_B = sensor.p_BS_B;
  q_SB = sensor.q_SB;
  % transform sensor coordinate frame to MARS conventions, and plot
  q_plotPose(p_BS_B, [-q_SB(2:4);q_SB(1)], sensor.name, 0.01);
  plot3([0, p_BS_B(1)], [0, p_BS_B(2)], [0, p_BS_B(3)], 'k');
end

end
