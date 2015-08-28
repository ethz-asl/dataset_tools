% ------------------------------------------------------------------------------
% Function : plot body
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------


function dataset_plot_body(body)

NSensor = length(body.sensor);

% plot body
q_plotPose(zeros(3, 1), [1;0;0;0], body.name, 0.03);
hold on;

% plot sensors
for iSensor = 1:NSensor
  sensor = body.sensor{iSensor};
  %p_BS_B = sensor.p_BS_B;
  p_BS_B = sensor.T_BS(1:3, 4);
  %q_SB = sensor.q_SB;
  C_BS = sensor.T_BS(1:3, 1:3);
  q_SB = q_C2q(C_BS);
  % transform sensor coordinate frame to MARS conventions, and plot
  q_plotPose(p_BS_B, q_SB, sensor.name, 0.015);
  plot3([0, p_BS_B(1)], [0, p_BS_B(2)], [0, p_BS_B(3)], 'k');
end

end
