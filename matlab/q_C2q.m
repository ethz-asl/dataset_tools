% ------------------------------------------------------------------------------
% Function : dcm to quaternion
% Project  : IJRR MAV Datasets
% Author   : www.asl.ethz.ch
% Version  : V01  28AUG2015 Initial version.
% Comment  :
% Status   : under review
% ------------------------------------------------------------------------------

function q = q_C2q(C)

% make sure rotation matrix is proper (det(R) = +1)
assert(det(C) > 0);

m00 = C(1,1);
m10 = C(2,1);
m20 = C(3,1);

m01 = C(1,2);
m11 = C(2,2);
m21 = C(3,2);

m02 = C(1,3);
m12 = C(2,3);
m22 = C(3,3);

tr = m00 + m11 + m22;

% compute quaternion from rotation matrix
if (tr > 0)
    S = sqrt(tr+1.0) * 2;
    qw = 0.25 * S;
    qx = (m21 - m12) / S;
    qy = (m02 - m20) / S;
    qz = (m10 - m01) / S;
else
    if ((m00 > m11)&&(m00 > m22))
        S = sqrt(1.0 + m00 - m11 - m22) * 2;
        qw = (m21 - m12) / S;
        qx = 0.25 * S;
        qy = (m01 + m10) / S;
        qz = (m02 + m20) / S;
    elseif (m11 > m22)
        S = sqrt(1.0 + m11 - m00 - m22) * 2;
        qw = (m02 - m20) / S;
        qx = (m01 + m10) / S;
        qy = 0.25 * S;
        qz = (m12 + m21) / S;
    else
        S = sqrt(1.0 + m22 - m00 - m11) * 2;
        qw = (m10 - m01) / S;
        qx = (m02 + m20) / S;
        qy = (m12 + m21) / S;
        qz = 0.25 * S;
    end
end

q = [-qw;qx;qy;qz];

q = q_min(q);
    
end

