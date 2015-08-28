% ------------------------------------------------------------------------------
% Function : skew-symmetric matrix operator
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function W = skewOp(w)
  W = [ 0,   -w(3), w(2);
        w(3), 0,   -w(1);
       -w(2), w(1), 0];
end
