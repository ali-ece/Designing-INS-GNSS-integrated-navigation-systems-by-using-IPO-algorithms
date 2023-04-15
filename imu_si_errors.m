function imu_si = imu_si_errors(imu, dt)
% Ali Mohammadi_INS/GNSS

% imu_err_profile: converts IMU errors manufacturer units to SI units.
%
% INPUT:
%		imu, data structure with IMU error profile in manufacturer units.
%         imu.arw:      angle random walks [X Y Z] (deg/root-hour)
%         imu.arrw:     angle rate random walks [X Y Z] (deg/root-hour/s)
%         imu.vrw:      velocity random walks [X Y Z] (m/s/root-hour)
%		      imu.vrrw:     velocity rate random walks [X Y Z] (deg/root-hour/s)
%         imu.gb_sta:   gyro static biases [X Y Z] (deg/s)
%         imu.ab_sta:   acc static biases [X Y Z] (mg)
%         imu.gb_dyn:   gyro dynamic biases [X Y Z] (deg/s)
%         imu.ab_dynt:  acc dynamic biases [X Y Z] (mg)
%         imu.gb_corr:  gyro correlation times [X Y Z] (seconds)
%         imu.ab_corr:  acc correlation times [X Y Z] (seconds)
%         imu.m_psd:    magnetometer noise density [X Y Z] (mgauss/root-Hz)
%		dt:  IMU sampling interval.
%
% OUTPUT:
%		imu_si: data structure with IMU error profile in SI units.
%%

D2R = (pi/180);     % deg to rad
G   =  9.80665;     % g to m/s^2

% Copy previois fields
imu_si = imu;

% Noise PSD
imu_si.arw = (imu.arw ./ 60) .* D2R;   % deg/root-hour -> rad/s/root-Hz
imu_si.vrw = (imu.vrw ./ 60);          % m/s/root-hour -> m/s^2/root-Hz

% Standard deviation
imu_si.a_std   = imu_si.vrw ./ sqrt(dt); % m/s^2/root-Hz  ->  m/s^2
imu_si.g_std   = imu_si.arw ./ sqrt(dt); % rad/s/root-Hz  ->  rad/s

% Static bias
imu_si.ab_sta = imu.ab_sta .* 0.001 * G;    % mg -> m/s^2
imu_si.gb_sta = imu.gb_sta .* D2R;          % deg/s -> rad/s;

% Dynamic bias
imu_si.ab_dyn = imu.ab_dyn .* 0.001 .* G;   % mg -> m/s^2
imu_si.gb_dyn = imu.gb_dyn .* D2R;          % deg/s -> rad/s;

% Dynamic bias PSD
if (isinf(imu.gb_corr))
    imu_si.gb_psd = imu_si.gb_dyn;          % rad/s (approximation)
else
    imu_si.gb_psd = imu_si.gb_dyn .* sqrt(imu.gb_corr);  % rad/s/root-Hz; 
end

if (isinf(imu.ab_corr))
    imu_si.ab_psd = imu_si.ab_dyn;          % m/s^2 (approximation)
else
    imu_si.ab_psd = imu_si.ab_dyn .* sqrt(imu.ab_corr);  % m/s^2/root-Hz
end

% Correlation time
imu_si.ab_corr = imu.ab_corr;
imu_si.gb_corr = imu.gb_corr;

% MAG
%imu_nav.mstd = (imu.m_psd .* 1e-3) ./ sqrt(dt) .* 1e-4; % mgauss/root-Hz -> tesla

end
