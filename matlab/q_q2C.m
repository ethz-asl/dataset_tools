% ------------------------------------------------------------------------------
% Function : Quaternion to rotation matrix conversion
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 15 JAN 2013 Initial version
%            V02 02 APR 2014 Added references
%            V03 04JUN2014   Removed assertion for speed
%                07JUL2015   Unmexed
% Comment  : Follows [1] (78)
% Status   : Verified that code reflects eqs. in references. Gives inverse of
%                what is implemented in Eigen and Stefans old matlab code.
%
% q        : 4x1 quaternion, [qx; qy; qz; qw]
%
% R        : 3x3 rotation matrix
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% ------------------------------------------------------------------------------

function C = q_q2C(q)

q0 = q(1);
q_ = q(2:4);

% Hannes
C = q0^2*eye(3)+2*q0*skewOp(q_)+skewOp(q_)^2 + q_*q_';

end
