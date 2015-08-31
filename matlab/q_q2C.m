% ------------------------------------------------------------------------------
% Function : quaternion to dcm
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function C = q_q2C(q)

qw = q(1);
q_ = q(2:4);

C = qw^2*eye(3)+2*qw*skewOp(q_)+skewOp(q_)^2 + q_*q_';

end
