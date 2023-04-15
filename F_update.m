function  [F, G] = F_update(upd, DCMbn, imu)
% Ali Mohammadi_INS/GNSS

% F_update: updates F and G matrices before the execution of Kalman filter.
%
% INPUT:
%   upd, 1x8 vector with data from the INS.
%   DCMbn, DCM body-to-nav.
%   imu, IMU data structure.
%
% OUTPUT:
%   F,  21x21 state transition matrix.
%   G,  21x12 control-input matrix.   
%
%   Output values preserve the precision of latitude, single or double 
%   precision.
%%

Vn =  upd(1);
Ve =  upd(2);
Vd =  upd(3);
lat = upd(4);
h   = upd(5);
fn =  upd(6);
fe =  upd(7);
fd =  upd(8);

if (isa(lat,'single'))
    Om = single(7.292115e-5);
    I = single(eye(3));
    Z = single(zeros(3));
else
    Om = 7.292115e-5;
    I = eye(3);
    Z = zeros(3);
end

[RM,RN] = radius(lat);
    
RO = sqrt(RN*RM);

a11 = 0;
a12 = -( (Om * sin(lat)) + (Ve / RO * tan(lat)) );
a13 = Vn / RO;
a21 = (Om * sin(lat)) + (Ve / RO * tan(lat));
a22 = 0 ;
a23 = (Om * cos(lat)) + (Ve / RO) ;
a31 = -Vn / RO;
a32 = -Om * cos(lat) - (Ve / RO);
a33 = 0;
Fee = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

a11 = 0;
a12 = 1 / RO;
a13 = 0;
a21 = -1 / RO;
a22 = 0;
a23 = 0;
a31 = 0;
a32 = -tan(lat) / RO;
a33 = 0;
Fev = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

a11 = -Om * sin(lat);
a12 = 0;
a13 = -Ve / (RO^2);
a21 = 0 ;
a22 = 0 ;
a23 = Vn / (RO^2);
a31 =  -Om * cos(lat) - (Ve / ((RO) * (cos(lat))^2));
a32 = 0 ;
a33 = (Ve * tan(lat)) / (RO^2) ;
Fep = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

a11 = 0 ;
a12 = -fd ;
a13 = fe ;
a21 = fd ;
a22 = 0 ;
a23 = -fn ;
a31 = -fe ;
a32 = fn ;
a33 = 0 ;
Fve = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

a11 = Vd / RO;
a12 = -2 * ((Om * sin(lat)) + ((Ve / RO) * tan(lat))) ;
a13 = Vn / RO ;
a21 = (2 * Om * sin(lat)) + ( (Ve / RO) * tan(lat) );
a22 = (1 / RO) * ((Vn * tan(lat)) + Vd) ;
a23 = 2 * Om * cos(lat) + (Ve / RO);
a31 = (-2 * Vn) / RO;
a32 = -2 * (Om * cos(lat) +  (Ve / RO)) ;
a33 = 0;
Fvv = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

a11 = -Ve * ((2 * Om * cos(lat)) + (Ve / (RO * (cos(lat))^2)));
a12 = 0 ;
a13 = (1 / RO^2) * ( (Ve^2 * tan(lat)) - (Vn * Vd) );
a21 = 2 * Om * ( (Vn * cos(lat)) - (Vd * sin(lat)) ) + ( (Vn * Ve) / (RO * (cos(lat))^2) ) ;
a22 = 0 ;
a23 = -(Ve / RO^2) * (Vn * tan(lat) + Vd);
a31 = 2 * Om * Ve * sin(lat);
a32 = 0;
a33 = (1 / RO^2) * (Vn^2 + Ve^2);
Fvp = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

Fpe = zeros(3);

a11 = 1 / RO;
a12 = 0;
a13 = 0;
a21 = 0;
a22 = 1 / (RO * cos(lat));
a23 = 0;
a31 = 0;
a32 = 0;
a33 = -1;
Fpv = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

a11 = 0;
a12 = 0;
a13 = -Vn / RO^2;
a21 = (Ve * tan(lat)) / (RO * cos(lat));
a22 = 0;
a23 = -Ve / (RO^2 * cos(lat));
a31 = 0;
a32 = 0;
a33 = 0;
Fpp = [a11 a12 a13; a21 a22 a23; a31 a32 a33;];

if (isinf(imu.ab_corr))
    Faa = Z;
else
    Faa = diag(-1./imu.ab_corr);
end

if (isinf(imu.gb_corr))
    Fgg = Z;
else
    Fgg = diag(-1./imu.gb_corr);
end

F = [Fee  Fev  Fep   (DCMbn)   Z;
     Fve  Fvv  Fvp   Z       (-DCMbn);
     Fpe  Fpv  Fpp   Z       Z;
     Z    Z    Z     Fgg     Z;
     Z    Z    Z     Z       Faa;
    ];

G = [DCMbn  Z     Z    Z;
    Z      -DCMbn 	Z    Z;
    Z      Z     	Z    Z;
    Z      Z     	I    Z;
    Z      Z     	Z    I;];
end
