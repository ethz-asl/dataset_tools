% ------------------------------------------------------------------------------
% Function : plot target observations
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function dataset_plot_target_observations(body)

NSensor = length(body.sensor);
SubsampleFactor = 10;
ObservationScale = 2.0;

for iSensor = 1:NSensor
    sensor = body.sensor{iSensor};
    if(strcmp(sensor.sensor_type, 'camera_target'))
        targetPoints = body.sensor{iSensor}.data.targetPoints_;
        undistortedMeasurements_ = body.sensor{iSensor}.data.undistortedMeasurements_;
        T_TC_ = body.sensor{iSensor}.data.T_TC_;
        q_TC_ = body.sensor{iSensor}.data.q_TC_;
        p_TC_T_ = body.sensor{iSensor}.data.p_TC_T_;
        NTrajectory = size(p_TC_T_, 2);
        
        figure();
        hold on;
        
        % plot target points
        plot3(targetPoints(1,:), targetPoints(2,:), targetPoints(3,:), 'k+');
        title(['target points. body: ', body.name]);
        xlabel('x [m]');
        ylabel('y [m]');
        zlabel('z [m]');
        
        % plot camera poses
        q_plotPose(p_TC_T_(:, 1), q_TC_(:, 1), '', 0.5);        
        for i=SubsampleFactor+1:SubsampleFactor:NTrajectory
            q_plotPose(p_TC_T_(:, i), q_TC_(:, i), '', 0.05);
        end
        plot3(p_TC_T_(1, :), p_TC_T_(2, :), p_TC_T_(3, :), 'k');
        
        % plot observations
        NCorners = size(undistortedMeasurements_{1}, 2);
        for iCorners = 1:NCorners
            p_TC_T = p_TC_T_(:, 1);
            p_TP_T = p_TC_T + q_q2C(q_TC_(:, 1)) * ObservationScale * undistortedMeasurements_{1}(:, iCorners);
            plot3([p_TC_T(1), p_TP_T(1)], ...
                  [p_TC_T(2), p_TP_T(2)], ...
                  [p_TC_T(3), p_TP_T(3)], 'g');
        end
        
        axis equal;
        grid on;
        
        title(['target poses. body: ', body.name]);
        xlabel('x [m]');
        ylabel('y [m]');
        zlabel('z [m]');
    end
end

end
