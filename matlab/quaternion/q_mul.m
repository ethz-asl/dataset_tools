% ------------------------------------------------------------------------------
% Function : quaternion multiplication
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  25SEP2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function r = q_mul(q, p)

assert(q(1) >= 0);
assert(p(1) >= 0);

r = [ - q(2)*p(2) - q(3)*p(3) - q(4)*p(4) + q(1)*p(1) ;
    + q(1)*p(2) + q(4)*p(3) - q(3)*p(4) + q(2)*p(1) ;
    - q(4)*p(2) + q(1)*p(3) + q(2)*p(4) + q(3)*p(1) ;
    + q(3)*p(2) - q(2)*p(3) + q(1)*p(4) + q(4)*p(1) ];
   
 r = q_min(r);
end
