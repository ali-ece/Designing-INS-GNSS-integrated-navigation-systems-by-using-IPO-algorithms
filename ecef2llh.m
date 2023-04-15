function [lat, lon, h] = ecef2llh(ecef)
% Ali Mohammadi_INS/GNSS

% ecef2llh:	converts from ECEF coordinates to navigation coordinates
%  (latitude, longitude and altitude).
%
% INPUTS
%   ecef: Nx3 ECEF coordinates [X Y Z] (m, m, m).
%
% OUTPUTS
%   lat: Nx1 latitude (radians).
%   lon: Nx1 longitude (radians).
%   h:   Nx1 altitude above ellipsoid (meters).
%%

x = ecef(:,1);
y = ecef(:,2);
z = ecef(:,3);

a = 6378137.0000;	% Earth radius in meters
% b = 6356752.3142;	% Earth semiminor in meters
e = 0.0818191908426;% Eccentricity

p = (x.^2 + y.^2) ./ a^2;
q = ((1-e^2) * z.^2) ./ a^2 ;
r = (p + q - e^4) ./ 6;
s = (e^4 * p .* q) ./ (4 * r.^3);
t = (1 + s + sqrt(s .* (2+s)) ) .^ (1/3);
u = r .* (1 + t + ( 1./t ) );
v = sqrt( u.^2 + q .* e.^4);
w = e.^2 .* ( u + v - q ) ./ ( 2 .* v );
k = sqrt( u + v + w.^2 ) - w;

D = k .* sqrt(x.^2 + y.^2) ./ (k + e.^2);

% Latitude
%     llh(1) = 2 * atan((z /(D+sqrt(D^2 + z^2))));
lat = atan2(z , D);

% Longitude
%     llh(2) = 2 * atan((y /(x+sqrt(x^2 + y^2))));
lon = atan2(y , x);

% Altitude
h = (k + e.^2 -1) ./ k .* (sqrt(D.^2 + z.^2));

end
