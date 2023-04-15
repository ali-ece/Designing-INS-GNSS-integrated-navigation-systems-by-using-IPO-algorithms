function ecef = ned2ecef(ned, llh_org)
% Ali Mohammadi_INS/GNSS

% ecef2ned: converts from ECEF coordinates to NED coordinates.
%
% INPUTS
%   ned: Nx3 NED coordinates [X Y Z] (m, m, m)
%   llh_org: 1x3 system origin [lat, lon, h] (rad, rad, m).
%
% OUTPUTS
%   ecef: Nx3 ECEF coordinates [X Y Z] (m, m, m).
%%

lat = llh_org(1);
lon = llh_org(2);

ecef_org = llh2ecef(llh_org)';

slat = sin(lat);
clat = cos(lat);
slon = sin(lon);
clon = cos(lon);

R = [  -slat*clon  -slat*slon   clat; ...
       -slon          clon         0; ... 
       -clat*clon  -clat*slon  -slat];

[MAX, N] = size(ned);
ecef = zeros(MAX, N);

for i=1:MAX
    
    ecef_t = ecef_org + R' * ned(i, :)';
    ecef (i, :) = ecef_t';
end

