% ------------------------------------------------------------------------------
% Function : Rodrigues parameters to rotation matrix conversion.
% Project  : Tools
% Author   : ETH (www.eth.ch), Janosch Nikolic
% Version  : V01 03 JAN 2013 Initial version
%            V02 02 APR 2014 Added references
% Comment  : Follows [1] (202)
% Status   : Verified that code reflects eqs. in references
%
% r        : Rodrigues parameters with [r1;r2;r3].
%
% R        : 3x3 rotation matrix
%
% [1]      : Malcolm Shuster
%            A Survey of Attitude Representations.
% ------------------------------------------------------------------------------


function R = q_r2R(r)

% make sure input dimensions are correct
si = size(r);
assert(si(1)==3);
assert(si(2)==1);

% compute rotation matrix
R = 1/(1+r'*r)*((1-r'*r)*eye(3)+2*r*r'+2*skewOp(r));

end
