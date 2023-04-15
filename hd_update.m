function yawm = hd_update( mag, roll, pitch, D)
% Ali Mohammadi_INS/GNSS

% hd_update: estimates magnetic heading from magnetometer data.
%%

B = [ cos(pitch) sin(pitch)*sin(roll) -cos(roll)*sin(pitch); ...
    0 cos(roll) sin(roll); ];

magh = (B * mag');

yh = magh(2);
xh = magh(1);
atanh = atan2(yh, xh);

if xh < 0
    
    yawm =  pi - atanh ;
    
elseif (xh > 0 && yh < 0)
    
    yawm = -atanh ;
    
elseif (xh > 0 && yh > 0)
    
    yawm = 2*pi - atanh;
    
elseif (xh == 0 && yh < 0)
    
    yawm = pi/2;
    
elseif (xh == 0 && yh > 0)
    
    yawm = (3/2) * pi;
    
else
    
    warning('hd_update: default option!') ;
end

% Correct magnetic declination
yawm = yawm + D;

% Yaw must be in the range of [-pi pi]
if yawm < -pi
    
    yawm = yawm + 2*pi;
    
elseif yawm > pi
    
    yawm = yawm - 2*pi;
    
else
    % dumb
    yawm = yawm;    
end


