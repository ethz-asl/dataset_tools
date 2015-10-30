% ------------------------------------------------------------------------------
% Function : plot dataset trajectory
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function dataset_plot_inertial_sensor_measurements(body)

NSensor = length(body.sensor);

for iSensor = 1:NSensor
  sensor = body.sensor{iSensor};
  if(strcmp(sensor.sensor_type, 'imu'))
    a = body.sensor{iSensor}.data.a;
    omega = body.sensor{iSensor}.data.omega;
    t = double(body.sensor{iSensor}.data.t - body.sensor{iSensor}.data.t(1));
    
    figure();
    subplot(2, 1, 1);
    plot(t/1e9, a');
    title(['accelerometer measurements. body: ', body.name]);
    xlabel('t [s]');
    ylabel('a [m / s / s]');
    subplot(2, 1, 2);
    plot(t*1e-9, omega'/pi*180);
    title(['gyroscope measurements. body: ', body.name]);
    xlabel('t [s]');
    ylabel('omega [dps]');
  end
end

end
