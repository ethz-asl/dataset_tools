% ------------------------------------------------------------------------------
% Function : plot pose
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function q_plotPose(p_WB_W, q_BW, caption, scale)

I = eye(3);

C_WB = q_q2C(q_BW);
V = C_WB*I * scale;

plot3([0 V(1,1)] + p_WB_W(1),[0 V(2,1)] + p_WB_W(2),[0 V(3,1)] + p_WB_W(3),'r','LineWidth',2);  % x.
hold on;
plot3([0 V(1,2)] + p_WB_W(1),[0 V(2,2)] + p_WB_W(2),[0 V(3,2)] + p_WB_W(3),'g','LineWidth',2);  % y.
plot3([0 V(1,3)] + p_WB_W(1),[0 V(2,3)] + p_WB_W(2),[0 V(3,3)] + p_WB_W(3),'b','LineWidth',2);  % z.
text(p_WB_W(1), p_WB_W(2), p_WB_W(3), caption,'FontSize',6, 'BackgroundColor',[.7 .9 .7]);
xlabel 'x';
ylabel 'y';
zlabel 'z';

end
