% ------------------------------------------------------------------------------
% Function : Rodrigues Parameters to "S Matrix"
%            The S matrix relates rodrigues parameter rates angular rates
%                (expressed in world = space frame). w = S * d/dt r.
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 03 JAN 2013 Initial version
%            V02 02 APR 2014 Added references
% Comment  : Follows [1] (332)
% Status   : Verified that code reflects eqs. in references
%
% r        : Rodrigues parameters with [r1;r2;r3]
%
% S        : S matrix
%
% [1]      : Nikolas Trawny, Stergios Roumeliotis,
%            Indirect Kalman Filter for 3D Attitude Estimation.
%
% [1]      : Malcolm Shuster
%            A Survey of Attitude Representations.
% ------------------------------------------------------------------------------


function S = q_r2S(r)

% make sure input dimensions are correct
si = size(r);
assert(si(1)==3);
assert(si(2)==1);

% compute S matrix
S = 2/(1+r'*r)*(eye(3)-skewOp(r));

end
