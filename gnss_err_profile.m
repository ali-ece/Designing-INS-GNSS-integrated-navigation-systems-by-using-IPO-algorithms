function  gnss = gnss_err_profile (lat, h, gnss)
% Ali Mohammadi_INS/GNSS

% gps_err_profile: converts GPS standard deviation from meters to radians.
%
% INPUT
%   lat: 1x1 latitude (radians).
%   h:   1x1 altitude (meters).
%   gnss: GNSS data structure.
%
% OUTPUT
%   gnss.std: 1x3 position error profile (m, m, m).
%%

gnss.std =  zeros(1,3);

[RM, RN] = radius(lat);

gnss.std(1) = gnss.stdm(1) / (RM + h);                  
gnss.std(2) = gnss.stdm(2) / (RN + h) / cos (lat);    
gnss.std(3) = gnss.stdm(3);

end
