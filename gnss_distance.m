function [d, d_v] = gnss_distance (lat, lon)
% Ali Mohammadi_INS/GNSS

% gnss_distance: provides distance between geographic coordinates based on 
% haversine function.
%
% INPUT:
%       lat: Mx1 latitudes (radians).
%       lon: Mx1 longitudes (radians).
%
% OUTPUT:
%		d:  total distance in kilometeres.
%       d_v: M-1x1 incremental distances between near points in kilometeres.
%%

M = max ( size ( lat) );

d_v = zeros(M-1, 1);            % Incremental distances between near points

R = 6371;                       % Earth's radius in km

delta_lat = diff ( lat );   
    
delta_lon = diff ( lon );
    
for i = 1:M-1
   
    a = sin( delta_lat(i) / 2)^2 + cos( lat(i) )  * cos( lon(i) ) * ...
    sin( delta_lon(i) / 2)^2;

    c = 2 * atan2 ( sqrt(a), sqrt (1-a) );

    d_v(i) = R * c;                          % distance in km
end

d = sum(d_v);

