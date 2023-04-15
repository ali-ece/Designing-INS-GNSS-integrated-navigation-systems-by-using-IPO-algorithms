function ecef = llh2ecef(llh)
% Ali Mohammadi_INS/GNSS

% llh2ecef: converts from navigation coordinates (latitude, longitude and 
% altitude) to ECEF coordinates.
%
% INPUTS
%   llh: Nx3 LLH coordinates [lat, lon, h] (rad, rad, m).
%
% OUTPUTS
%   ned: Nx3 NED coordinates [X Y Z] (m, m, m).
%%

% Preallocate

ecef = zeros(size(llh));

lat = llh(:,1);
lon = llh(:,2);
h   = llh(:,3);

[~,RN] = radius(lat);

e = 0.0818191908426;    % Eccentricity 

slat = sin(lat);
clat = cos(lat);
clon = cos(lon);
slon = sin(lon);

ecef(:,1) = (RN + h) .* clat .* clon;
ecef(:,2) = (RN + h) .* clat .* slon;
ecef(:,3) = (RN *(1-e^2) + h) .* slat;

end
