% ------------------------------------------------------------------------------
% Function : Angular velocity to Omega matrix (for quaternion kinematics)
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 01 FEB 2013 Initial version
%            V02 02 APR 2014 Added references
%            V03 10 SEP 2014 Removed assertion checks
% Comment  : Follows [1] (108), [2] (27)
% Status   : Verified that code reflects eqs. in references
%
% w        : 3x1 angular velocity vector
%
% Omega    : 4x4 Omega matrix (see references)
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
% [2]      : John L. Crassidis,
%            Sigma-Point Kalman Filtering for Integrated GPS and Inertial
%                Navigation.
%            Note: There is an error in (23) of this reference (- sign missing).
% ------------------------------------------------------------------------------

function Omega = q_w2Omega(w)

% check if input dimensions are correct
%si = size(w);
%assert(si(1)==3);
%assert(si(2)==1);

% compute Omega matrix
Omega = [0 -w(1) -w(2) -w(3);
         w(1)    0  w(3) -w(2);
         w(2) -w(3)     0  w(1);
         w(3) w(2) -w(1)     0];
      
end
