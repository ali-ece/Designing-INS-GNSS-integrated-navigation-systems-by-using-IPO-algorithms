function omega_en_n = transportrate(lat, Vn, Ve, h)
% Ali Mohammadi_INS/GNSS

% transportrate: calculates the transport rate in the navigation frame.
%%

h = abs(h);

if (isa(Vn,'single')) 
    
    [RM,RN] = radius(lat, 'single');

    omega_en_n(1,1) = single(Ve /(RN + h));                 % North 
    omega_en_n(2,1) = single(-(Vn /(RM + h)));              % East
    omega_en_n(3,1) = single(-(Ve * tan(lat) / (RN + h)));  % Down
else
    
    [RM,RN] = radius(lat);

    omega_en_n(1,1) = (Ve /(RN + h));                 % North 
    omega_en_n(2,1) = (-(Vn /(RM + h)));              % East
    omega_en_n(3,1) = (-(Ve * tan(lat) / (RN + h)));  % Down
end                               

end
