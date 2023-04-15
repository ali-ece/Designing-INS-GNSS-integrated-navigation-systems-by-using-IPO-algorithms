function [Fitness] = fitness2(VV)

% Ali Mohammadi_INS/GNSS
% navego_example_synth: Example of how to use NaveGo to generate 
% synthetic (simulated) data and then fuse them.
% 
% Main goal: to compare two INS/GNSS systems performances, one using a 
% simulated ADIS16405 IMU and simulated GNSS, and another using a 
% simulated ADIS16488 IMU and the same simulated GNSS.

% clc
% close all
% clear
% matlabrc

addpath ../../
addpath ../../simulation/
addpath ../../conversions/

versionstr = 'NaveGo, release v1.2';

fprintf('\n%s.\n', versionstr)
fprintf('\nNaveGo: starting simulated INS/GNSS integration... \n')

%% CODE EXECUTION PARAMETERS

% Comment any of the following parameters in order to NOT execute a 
% particular portion of code

GNSS_DATA = 'ON';   % Generate synthetic GNSS data
IMU1_DATA = 'ON';   % Generate synthetic ADIS16405 IMU data
IMU2_DATA = 'ON';   % Generate synthetic ADIS16488 IMU data

IMU1_INS  = 'ON';   % Execute INS/GNSS integration for ADIS16405 IMU
IMU2_INS  = 'ON';   % Execute INS/GNSS integration for ADIS16488 IMU

PLOT      = 'ON';   % Plot results.

% If a particular parameter is commented above, it is set by default to 'OFF'.

if (~exist('GNSS_DATA','var')), GNSS_DATA  = 'OFF'; end
if (~exist('IMU1_DATA','var')), IMU1_DATA = 'OFF'; end
if (~exist('IMU2_DATA','var')), IMU2_DATA = 'OFF'; end
if (~exist('IMU1_INS','var')),  IMU1_INS  = 'OFF'; end
if (~exist('IMU2_INS','var')),  IMU2_INS  = 'OFF'; end
if (~exist('PLOT','var')),      PLOT      = 'OFF'; end

%% CONVERSION CONSTANTS

G =  9.80665;       % Gravity constant, m/s^2
G2MSS = G;          % g to m/s^2
MSS2G = (1/G);      % m/s^2 to g

D2R = (pi/180);     % degrees to radians
R2D = (180/pi);     % radians to degrees

KT2MS = 0.514444;   % knot to m/s
MS2KMH = 3.6;       % m/s to km/h

%% LOAD REFERENCE DATA

fprintf('NaveGo: loading reference dataset from a trajectory generator... \n')

load ref.mat

% ref.mat contains the reference data structure from which inertial 
% sensors and GNSS wil be simulated. It must contain the following fields:

%         t: Nx1 time vector (seconds).
%       lat: Nx1 latitude (radians).
%       lon: Nx1 longitude (radians).
%         h: Nx1 altitude (m).
%       vel: Nx3 NED velocities (m/s).
%      roll: Nx1 roll angles (radians).
%     pitch: Nx1 pitch angles (radians).
%       yaw: Nx1 yaw angle vector (radians).
%     DCMnb: Nx9 Direct Cosine Matrix nav-to-body. Each row contains 
%            the elements of one DCM matrix ordered by columns as 
%            [a11 a21 a31 a12 a22 a32 a13 a23 a33].
%      freq: sampling frequency (Hz).

%% ADIS16405 IMU error profile

% IMU data structure:
%         t: Ix1 time vector (seconds).
%        fb: Ix3 accelerations vector in body frame XYZ (m/s^2).
%        wb: Ix3 turn rates vector in body frame XYZ (radians/s).
%       arw: 1x3 angle random walks (rad/s/root-Hz).
%      arrw: 1x3 angle rate random walks (rad/s^2/root-Hz).
%       vrw: 1x3 velocity random walks (m/s^2/root-Hz).
%      vrrw: 1x3 velocity rate random walks (m/s^3/root-Hz).
%     g_std: 1x3 gyros standard deviations (radians/s).
%     a_std: 1x3 accrs standard deviations (m/s^2).
%    gb_sta: 1x3 gyros static biases or turn-on biases (radians/s).
%    ab_sta: 1x3 accrs static biases or turn-on biases (m/s^2).
%    gb_dyn: 1x3 gyros dynamic biases or bias instabilities (radians/s).
%    ab_dyn: 1x3 accrs dynamic biases or bias instabilities (m/s^2).
%   gb_corr: 1x3 gyros correlation times (seconds).
%   ab_corr: 1x3 accrs correlation times (seconds).
%    gb_psd: 1x3 gyros dynamic biases PSD (rad/s/root-Hz).
%    ab_psd: 1x3 accrs dynamic biases PSD (m/s^2/root-Hz);
%      freq: 1x1 sampling frequency (Hz).
% ini_align: 1x3 initial attitude at t(1), [roll pitch yaw] (rad).
% ini_align_err: 1x3 initial attitude errors at t(1), [roll pitch yaw] (rad).

ADIS16405.arw      = 2   .* ones(1,3);     % Angle random walks [X Y Z] (deg/root-hour)
ADIS16405.arrw     = zeros(1,3);           % Angle rate random walks [X Y Z] (deg/root-hour/s)
ADIS16405.vrw      = 0.2 .* ones(1,3);     % Velocity random walks [X Y Z] (m/s/root-hour)
ADIS16405.vrrw     = zeros(1,3);           % Velocity rate random walks [X Y Z] (deg/root-hour/s)
ADIS16405.gb_sta   = 3   .* ones(1,3);     % Gyro static biases [X Y Z] (deg/s)
ADIS16405.ab_sta   = 50  .* ones(1,3);     % Acc static biases [X Y Z] (mg)
ADIS16405.gb_dyn   = 0.007 .* ones(1,3);   % Gyro dynamic biases [X Y Z] (deg/s)
ADIS16405.ab_dyn   = 0.2 .* ones(1,3);     % Acc dynamic biases [X Y Z] (mg)
ADIS16405.gb_corr  = 100 .* ones(1,3);     % Gyro correlation times [X Y Z] (seconds)
ADIS16405.ab_corr  = 100 .* ones(1,3);     % Acc correlation times [X Y Z] (seconds)
ADIS16405.freq     = ref.freq;             % IMU operation frequency [X Y Z] (Hz)
% ADIS16405.m_psd     = 0.066 .* ones(1,3);  % Magnetometer noise density [X Y Z] (mgauss/root-Hz)

% ref dataset will be used to simulate IMU sensors.
ADIS16405.t = ref.t;                       % IMU time vector
dt = mean(diff(ADIS16405.t));              % IMU sampling interval

imu1 = imu_si_errors(ADIS16405, dt);       % Transform IMU manufacturer error units to SI units.

imu1.ini_align_err = [3 3 10] .* D2R;                   % Initial attitude align errors for matrix P in Kalman filter, [roll pitch yaw] (radians)  
imu1.ini_align = [ref.roll(1) ref.pitch(1) ref.yaw(1)]; % Initial attitude align at t(1) (radians).

%% ADIS16488 IMU error profile

ADIS16488.arw      = 0.3  .* ones(1,3);     % Angle random walks [X Y Z] (deg/root-hour)
ADIS16488.arrw     = zeros(1,3);            % Angle rate random walks [X Y Z] (deg/root-hour/s)
ADIS16488.vrw      = 0.029.* ones(1,3);     % Velocity random walks [X Y Z] (m/s/root-hour)
ADIS16488.vrrw     = zeros(1,3);            % Velocity rate random walks [X Y Z] (deg/root-hour/s)
ADIS16488.gb_sta   = 0.2  .* ones(1,3);     % Gyro static biases [X Y Z] (deg/s)
ADIS16488.ab_sta   = 16   .* ones(1,3);     % Acc static biases [X Y Z] (mg)
ADIS16488.gb_dyn   = 6.5/3600  .* ones(1,3);% Gyro dynamic biases [X Y Z] (deg/s)
ADIS16488.ab_dyn   = 0.1  .* ones(1,3);     % Acc dynamic biases [X Y Z] (mg)
ADIS16488.gb_corr  = 100  .* ones(1,3);     % Gyro correlation times [X Y Z] (seconds)
ADIS16488.ab_corr  = 100  .* ones(1,3);     % Acc correlation times [X Y Z] (seconds)
ADIS16488.freq     = ref.freq;              % IMU operation frequency [X Y Z] (Hz)
% ADIS16488.m_psd = 0.054 .* ones(1,3);       % Magnetometer noise density [X Y Z] (mgauss/root-Hz)

% ref dataset will be used to simulate IMU sensors.
ADIS16488.t = ref.t;                        % IMU time vector
dt = mean(diff(ADIS16488.t));               % IMU sampling interval

imu2 = imu_si_errors(ADIS16488, dt);        % Transform IMU manufacturer error units to SI units.

imu2.ini_align_err = [1 1 5] .* D2R;                     % Initial attitude align errors for matrix P in Kalman filter, [roll pitch yaw] (radians)  
imu2.ini_align = [ref.roll(1) ref.pitch(1) ref.yaw(1)];  % Initial attitude align at t(1) (radians).

%% Garmin 5-18 Hz GPS error profile

% GNSS data structure:
%         t: Mx1 time vector (seconds).
%       lat: Mx1 latitude (radians).
%       lon: Mx1 longitude (radians).
%         h: Mx1 altitude (m).
%       vel: Mx3 NED velocities (m/s).
%       std: 1x3 position standard deviations, [lat lon h] (rad, rad, m).
%      stdm: 1x3 position standard deviations, [lat lon h] (m, m, m).
%      stdv: 1x3 velocity standard deviations, [Vn Ve Vd] (m/s).
%      larm: 3x1 lever arm from IMU to GNSS antenna (x-fwd, y-right, z-down) (m).
%      freq: 1x1 sampling frequency (Hz).
%   zupt_th: 1x1 ZUPT threshold (m/s).
%  zupt_win: 1x1 ZUPT time window (seconds).
%       eps: 1x1 time interval to compare IMU time vector to GNSS time vector (seconds).

gnss.stdm = [5 5 10];                   % GNSS positions standard deviations [lat lon h] (meters)
gnss.stdv = 0.1 * KT2MS .* ones(1,3);   % GNSS velocities standard deviations [Vn Ve Vd] (meters/s)
gnss.larm = zeros(3,1);                 % GNSS lever arm from IMU to GNSS antenna (x-fwd, y-right, z-down) (m).
gnss.freq = 5;                          % GNSS operation frequency (Hz)

% Parameters for ZUPT detection algorithm
gnss.zupt_th = 0.5;   % ZUPT threshold (m/s).
gnss.zupt_win = 4;    % ZUPT time window (seconds).

gnss.eps = 1E-3;

% The following figure tries to show when the Kalman filter (KF) will be run.
% If a new element from GNSS time vector is available at the current INS time inside the window time
% set by epsilon, the Kalman filter (KF) will be executed.
%
%                    I1  I2  I3  I4  I5  I6  I7  I8  I9  I10 I11 I12 I3 
% INS time vector:   |---|---|---|---|---|---|---|---|---|---|---|---|
% Epsilon:          |-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|  
% GNSS time vector:  --|------|------|------|------|------|------|
%                      G1     G2     G4     G5     G6     G7     G8
% KF execution:               ^      ^      ^             ^      ^ 					 	
%
% It can be seen that the KF is not execute at G1 and G6 because of a wrong choice of epsilon.
%
% A longer epsilon will tend to not recognize a new GNSS input. On the other hand, a shorter 
% epsilon will tend to execute the KF using the same GNSS input.

%% GNSS SYNTHETIC DATA

rng('shuffle')                  % Reset pseudo-random seed

if strcmp(GNSS_DATA, 'ON')       % If simulation of GNSS data is required ...
    
    fprintf('NaveGo: generating GNSS synthetic data... \n')
    
    gnss = gnss_err_profile(ref.lat(1), ref.h(1), gnss); % Transform GNSS manufacturer error units to SI units.
    
    gnss = gnss_gen(ref, gnss);  % Generate GNSS dataset from reference dataset.

    save gnss.mat gnss
    
else
    
    fprintf('NaveGo: loading GNSS data... \n') 
    
    load gnss.mat
end

%% IMU1 SYNTHETIC DATA

rng('shuffle')                  % Reset pseudo-random seed

if strcmp(IMU1_DATA, 'ON')      % If simulation of IMU1 data is required ...
    
    fprintf('NaveGo: generating IMU1 ACCR synthetic data... \n')
    
    fb = acc_gen (ref, imu1);   % Generate acc in the body frame
    imu1.fb = fb;
    
    fprintf('NaveGo: generating IMU1 GYRO synthetic data... \n')
    
    wb = gyro_gen (ref, imu1);  % Generate gyro in the body frame
    imu1.wb = wb;
    
    save imu1.mat imu1
    
    clear wb fb;
    
else
    fprintf('NaveGo: loading IMU1 data... \n')
    
    load imu1.mat
end

%% IMU2 SYNTHETIC DATA

rng('shuffle')					% Reset pseudo-random seed

if strcmp(IMU2_DATA, 'ON')      % If simulation of IMU2 data is required ...
    
    fprintf('NaveGo: generating IMU2 ACCR synthetic data... \n')
    
    fb = acc_gen (ref, imu2);   % Generate acc in the body frame
    imu2.fb = fb;
    
    fprintf('NaveGo: generating IMU2 GYRO synthetic data... \n')
    
    wb = gyro_gen (ref, imu2);  % Generate gyro in the body frame
    imu2.wb = wb;
    
    save imu2.mat imu2
    
    clear wb fb;
    
else
    fprintf('NaveGo: loading IMU2 data... \n')
    
    load imu2.mat
end

%% Print navigation time

to = (ref.t(end) - ref.t(1));

fprintf('NaveGo: navigation time is %.2f minutes or %.2f seconds. \n', (to/60), to)

%% INS/GNSS integration using IMU1

if strcmp(IMU1_INS, 'ON')
    
    fprintf('NaveGo: INS/GNSS navigation estimates for IMU1... \n')
    
    % Execute INS/GNSS integration
    % ---------------------------------------------------------------------
    imu1.VV = VV;
    nav1_e = ins_gnss1(imu1, gnss, 'dcm');
    % ---------------------------------------------------------------------
    
    save nav1_e.mat nav1_e
    
else
    
    fprintf('NaveGo: loading INS/GNSS integration for IMU1... \n')
    
    load nav1_e.mat
end

%% INS/GNSS integration using IMU2

if strcmp(IMU2_INS, 'ON')
    
    fprintf('NaveGo: INS/GNSS navigation estimates for IMU2... \n')
    
    % Execute INS/GNSS integration
    % ---------------------------------------------------------------------
    imu2.VV = VV;
    nav2_e = ins_gnss1(imu2, gnss, 'quaternion');
    % ---------------------------------------------------------------------
    
    save nav2_e.mat nav2_e
    
else
    
    fprintf('NaveGo: loading INS/GNSS integration for IMU2... \n')
    
    load nav2_e.mat
end

%% Interpolate INS/GNSS dataset 

% INS/GNSS estimates and GNSS data are interpolated according to the
% reference dataset.

[nav1_r, ref_1] = navego_interpolation (nav1_e, ref);
[nav2_r, ref_2] = navego_interpolation (nav2_e, ref);
[gnss_r, ref_g] = navego_interpolation (gnss, ref);

%% Print RMSE from IMU1
% ---------------------------------------------------------------------
print_rmse (nav1_r, gnss_r, ref_1, ref_g, 'ADIS16405 INS/GNSS');
% ---------------------------------------------------------------------
%% Print RMSE from IMU2
% ---------------------------------------------------------------------
print_rmse (nav2_r, gnss_r, ref_2, ref_g, 'ADIS16488 INS/GNSS');
% .m_psd = 0.054 .* ones(1,3);       % Magnetometer noise density [X Y Z] (mgauss/root-Hz)
% ---------------------------------------------------------------------

%% PLOT

if (strcmp(PLOT,'ON'))
    
    sig3_rr = abs(nav1_e.Pp(:, 1:16:end).^(0.5)) .* 3; % Only take diagonal elements from Pp
    
    % TRAJECTORY
    figure;
    plot3(ref.lon.*R2D, ref.lat.*R2D, ref.h, '--k')
    hold on
    plot3(nav1_e.lon.*R2D, nav1_e.lat.*R2D, nav1_e.h, 'b')
    plot3(nav2_e.lon.*R2D, nav2_e.lat.*R2D, nav2_e.h, 'r')
    plot3(ref.lon(1).*R2D, ref.lat(1).*R2D, ref.h(1), 'or', 'MarkerSize', 10, 'LineWidth', 2)
    axis tight
    title('TRAJECTORIES')
    xlabel('Longitude [deg]')
    ylabel('Latitude [deg]')
    zlabel('Altitude [m]')
    view(-25,35)
    legend('TRUE', 'IMU1', 'IMU2')
    grid
    
    % ATTITUDE
    figure;
    subplot(311)
    plot(ref.t, R2D.*ref.roll, '--k', nav1_e.t, R2D.*nav1_e.roll,'-b', nav2_e.t, R2D.*nav2_e.roll,'-r');
    ylabel('[deg]')
    xlabel('Time [s]')
    legend('REF', 'IMU1', 'IMU2');
    title('ROLL');
    grid
    
    subplot(312)
    plot(ref.t, R2D.*ref.pitch, '--k', nav1_e.t, R2D.*nav1_e.pitch,'-b', nav2_e.t, R2D.*nav2_e.pitch,'-r');
    ylabel('[deg]')
    xlabel('Time [s]')
    legend('REF', 'IMU1', 'IMU2');
    title('PITCH');
    grid
    
    subplot(313)
    plot(ref.t, R2D.* ref.yaw, '--k', nav1_e.t, R2D.*nav1_e.yaw,'-b', nav2_e.t, R2D.*nav2_e.yaw,'-r');
    ylabel('[deg]')
    xlabel('Time [s]')
    legend('REF', 'IMU1', 'IMU2');
    title('YAW');
    grid
    
    % ATTITUDE ERRORS
    figure;
    subplot(311)
    plot(nav1_e.t, (nav1_r.roll - ref_1.roll).*R2D, '-b', nav2_r.t, (nav2_r.roll - ref_2.roll).*R2D, '-r');
    hold on
    plot (gnss.t, R2D.*sig3_rr(:,1), '--k', gnss.t, -R2D.*sig3_rr(:,1), '--k' )
    ylabel('[deg]')
    xlabel('Time [s]')
    legend('IMU1', 'IMU2', '3\sigma');
    title('ROLL ERROR');
    grid
    
    subplot(312)
    plot(nav1_e.t, (nav1_r.pitch - ref_1.pitch).*R2D, '-b', nav2_r.t, (nav2_r.pitch - ref_2.pitch).*R2D, '-r');
    hold on
    plot (gnss.t, R2D.*sig3_rr(:,2), '--k', gnss.t, -R2D.*sig3_rr(:,2), '--k' )
    ylabel('[deg]')
    xlabel('Time [s]')
    legend('IMU1', 'IMU2', '3\sigma');
    title('PITCH ERROR');
    grid
    
    subplot(313)
    yaw1_err = correct_yaw(nav1_r.yaw - ref_1.yaw);
    yaw2_err = correct_yaw(nav2_r.yaw - ref_2.yaw);
    plot(nav1_e.t, (yaw1_err).*R2D, '-b', nav2_r.t, (yaw2_err).*R2D, '-r');
    hold on
    plot (gnss.t, R2D.*sig3_rr(:,3), '--k', gnss.t, -R2D.*sig3_rr(:,3), '--k' )
    ylabel('[deg]')
    xlabel('Time [s]')
    legend('IMU1', 'IMU2', '3\sigma');
    title('YAW ERROR');
    grid
    
    % VELOCITIES
    figure;
    subplot(311)
    plot(ref.t, ref.vel(:,1), '--k', gnss.t, gnss.vel(:,1),'-c', nav1_e.t, nav1_e.vel(:,1),'-b', nav2_e.t, nav2_e.vel(:,1),'-r');
    xlabel('Time [s]')
    ylabel('[m/s]')
    legend('REF', 'GNSS', 'IMU1', 'IMU2');
    title('NORTH VELOCITY');
    grid
    
    subplot(312)
    plot(ref.t, ref.vel(:,2), '--k', gnss.t, gnss.vel(:,2),'-c', nav1_e.t, nav1_e.vel(:,2),'-b', nav2_e.t, nav2_e.vel(:,2),'-r');
    xlabel('Time [s]')
    ylabel('[m/s]')
    legend('REF', 'GNSS', 'IMU1', 'IMU2');
    title('EAST VELOCITY');
    grid
    
    subplot(313)
    plot(ref.t, ref.vel(:,3), '--k', gnss.t, gnss.vel(:,3),'-c', nav1_e.t, nav1_e.vel(:,3),'-b', nav2_e.t, nav2_e.vel(:,3),'-r');
    xlabel('Time [s]')
    ylabel('[m/s]')
    legend('REF', 'GNSS', 'IMU1', 'IMU2');
    title('DOWN VELOCITY');
    grid
    
    % VELOCITIES ERRORS
    figure;
    subplot(311)
    plot(gnss_r.t, (gnss_r.vel(:,1) - ref_g.vel(:,1)), '-c');
    hold on
    plot(nav1_r.t, (nav1_r.vel(:,1) - ref_1.vel(:,1)), '-b', nav2_r.t, (nav2_r.vel(:,1) - ref_2.vel(:,1)), '-r');
    plot (gnss.t, sig3_rr(:,4), '--k', gnss.t, -sig3_rr(:,4), '--k' )
    xlabel('Time [s]')
    ylabel('[m/s]')
    legend('GNSS', 'IMU1', 'IMU2', '3\sigma');
    title('VELOCITY NORTH ERROR');
    grid
    
    subplot(312)
    plot(gnss_r.t, (gnss_r.vel(:,2) - ref_g.vel(:,2)), '-c');
    hold on
    plot(nav1_r.t, (nav1_r.vel(:,2) - ref_1.vel(:,2)), '-b', nav2_r.t, (nav2_r.vel(:,2) - ref_2.vel(:,2)), '-r');
    plot (gnss.t, sig3_rr(:,5), '--k', gnss.t, -sig3_rr(:,5), '--k' )
    xlabel('Time [s]')
    ylabel('[m/s]')
    legend('GNSS', 'IMU1', 'IMU2', '3\sigma');
    title('VELOCITY EAST ERROR');
    grid
    
    subplot(313)
    plot(gnss_r.t, (gnss_r.vel(:,3) - ref_g.vel(:,3)), '-c');
    hold on
    plot(nav1_r.t, (nav1_r.vel(:,3) - ref_1.vel(:,3)), '-b', nav2_r.t, (nav2_r.vel(:,3) - ref_2.vel(:,3)), '-r');
    plot (gnss.t, sig3_rr(:,6), '--k', gnss.t, -sig3_rr(:,6), '--k' )
    xlabel('Time [s]')
    ylabel('[m/s]')
    legend('GNSS', 'IMU1', 'IMU2', '3\sigma');
    title('VELOCITY DOWN ERROR');
    grid
    
    % POSITION
    figure;
    subplot(311)
    plot(ref.t, ref.lat .*R2D, '--k', gnss.t, gnss.lat.*R2D, '-c', nav1_e.t, nav1_e.lat.*R2D, '-b', nav2_e.t, nav2_e.lat.*R2D, '-r');
    xlabel('Time [s]')
    ylabel('[deg]')
    legend('REF', 'GNSS', 'IMU1', 'IMU2');
    title('LATITUDE');
    grid
    
    subplot(312)
    plot(ref.t, ref.lon .*R2D, '--k', gnss.t, gnss.lon.*R2D, '-c', nav1_e.t, nav1_e.lon.*R2D, '-b', nav2_e.t, nav2_e.lon.*R2D, '-r');
    xlabel('Time [s]')
    ylabel('[deg]')
    legend('REF', 'GNSS', 'IMU1', 'IMU2');
    title('LONGITUDE');
    grid
    
    subplot(313)
    plot(ref.t, ref.h, '--k', gnss.t, gnss.h, '-c', nav1_e.t, nav1_e.h, '-b', nav2_e.t, nav2_e.h, '-r');
    xlabel('Time [s]')
    ylabel('[m]')
    legend('REF', 'GNSS', 'IMU1', 'IMU2');
    title('ALTITUDE');
    grid
    
    % POSITION ERRORS    
    [RN,RE]  = radius(nav1_r.lat);
    LAT2M_1 = RN + nav1_r.h;
    LON2M_1 = (RE + nav1_r.h).*cos(nav1_r.lat);
    
    [RN,RE]  = radius(nav2_r.lat);
    LAT2M_2 = RN + nav2_r.h;
    LON2M_2 = (RE + nav2_r.h).*cos(nav2_r.lat);
    
    [RN,RE]  = radius(gnss.lat);
    LAT2M_G = RN + gnss.h;
    LON2M_G = (RE + gnss.h).*cos(gnss.lat);
    
    [RN,RE]  = radius(gnss_r.lat);
    LAT2M_GR = RN + gnss_r.h;
    LON2M_GR = (RE + gnss_r.h).*cos(gnss_r.lat);
    
    figure;
    subplot(311)
    plot(gnss_r.t,  LAT2M_GR.*(gnss_r.lat - ref_g.lat), '-c')
    hold on
    plot(nav1_r.t, LAT2M_1.*(nav1_r.lat - ref_1.lat), '-b')
    plot(nav2_r.t, LAT2M_2.*(nav2_r.lat - ref_2.lat), '-r')
    plot (gnss.t, LAT2M_G.*sig3_rr(:,7), '--k', gnss.t, -LAT2M_G.*sig3_rr(:,7), '--k' )
    xlabel('Time [s]')
    ylabel('[m]')
    legend('GNSS', 'IMU1', 'IMU2', '3\sigma');
    title('LATITUDE ERROR');
    grid
    
    subplot(312)
    plot(gnss_r.t, LON2M_GR.*(gnss_r.lon - ref_g.lon), '-c')
    hold on
    plot(nav1_r.t, LON2M_1.*(nav1_r.lon - ref_1.lon), '-b')
    plot(nav2_r.t, LON2M_2.*(nav2_r.lon - ref_2.lon), '-r')
    plot(gnss.t, LON2M_G.*sig3_rr(:,8), '--k', gnss.t, -LON2M_G.*sig3_rr(:,8), '--k' )
    xlabel('Time [s]')
    ylabel('[m]')
    legend('GNSS', 'IMU1', 'IMU2', '3\sigma');
    title('LONGITUDE ERROR');
    grid
    
    subplot(313)
    plot(gnss_r.t, (gnss_r.h - ref_g.h), '-c')
    hold on
    plot(nav1_r.t, (nav1_r.h - ref_1.h), '-b')
    plot(nav2_r.t, (nav2_r.h - ref_2.h), '-r')
    plot(gnss.t, sig3_rr(:,9), '--k', gnss.t, -sig3_rr(:,9), '--k' )
    xlabel('Time [s]')
    ylabel('[m]')
    legend('GNSS', 'IMU1', 'IMU2', '3\sigma');
    title('ALTITUDE ERROR'); 
    grid
end

% ---------------------------------------------------------------------

% Fitness = sum(Sum1(1:9)+Sum2(1:9));

% ---------------------------------------------------------------------

end
