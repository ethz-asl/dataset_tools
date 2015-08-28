% ------------------------------------------------------------------------------
% Function : quaternion to dcm
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function C = q_q2C(q)

q0 = q(1);
q_ = q(2:4);

C = q0^2*eye(3)+2*q0*skewOp(q_)+skewOp(q_)^2 + q_*q_';

end
