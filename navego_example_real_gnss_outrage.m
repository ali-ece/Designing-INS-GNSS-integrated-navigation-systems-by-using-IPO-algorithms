% Ali Mohammadi_INS/GNSS
% navego_example_real_gnss_outrage: post-processing integration of MPU-6000 
% IMU and Ekinox GNSS data. Two GNSS outrage paths are forced.
%
% Main goal: to integrate MPU-6000 IMU and Ekinox-D GNSS measurements and 
% test INS/GNSS systems performance under two GNSS outrage.
%
% Sensors dataset was generated driving a vehicle through the streets of
% Turin city (Italy).

clc
close all
clear
matlabrc

addpath ../../
addpath ../../simulation/
addpath ../../conversions/

versionstr = 'NaveGo, release v1.2';

fprintf('\n%s.\n', versionstr)
fprintf('\nNaveGo: starting real INS/GNSS integration... \n')

%% PARAMETERS

% Comment any of the following parameters in order to NOT execute a
% particular portion of code

INS_GNSS = 'ON';
GNSS_OUTRAGE = 'ON';
PLOT     = 'ON';

if (~exist('INS_GNSS','var')), INS_GNSS = 'OFF'; end
if (~exist('PLOT','var')),     PLOT     = 'OFF'; end
if (~exist('GNSS_OUTRAGE','var')),      GNSS_OUTRAGE = 'OFF'; end

%% CONVERSION CONSTANTS

G =  9.80665;       % Gravity constant, m/s^2
G2MSS = G;          % g to m/s^2
MSS2G = (1/G);      % m/s^2 to g

D2R = (pi/180);     % degrees to radians
R2D = (180/pi);     % radians to degrees

KT2MS = 0.514444;   % knot to m/s
MS2KMH = 3.6;       % m/s to km/h

%% LOAD REF DATA

% Reference dataset was obtained by processing Ekinox IMU and Ekinox GNSS
% with tighly-coupled integration by Inertial Explorer software package.

% Dataset from time 138000 (TOW) to 139255 (TOW).

fprintf('NaveGo: loading reference data... \n')

load ref

%% EKINOX IMU

fprintf('NaveGo: loading Ekinox IMU data... \n')

load mpu6000_imu

%% EKINOX GNSS

fprintf('NaveGo: loading Ekinox GNSS data... \n')

load ekinox_gnss

% Force two GNSS outrage paths

% GNSS OUTRAGE TIME INTERVAL 1
tor1_min = 138906;
tor1_max = 138906 + 32;

% GNSS OUTRAGE TIME INTERVAL 2
tor2_min = 139170;
tor2_max = 139170 + 32;

if (strcmp(GNSS_OUTRAGE, 'ON'))
    
    fprintf('NaveGo: two GNSS outrages are forced... \n')
    
    % GNSS OUTRAGE 1
    idx  = find(ekinox_gnss.t > tor1_min, 1, 'first' );
    fdx  = find(ekinox_gnss.t < tor1_max, 1, 'last' );
    
    ekinox_gnss.t(idx:fdx) = [];
    ekinox_gnss.lat(idx:fdx) = [];
    ekinox_gnss.lon(idx:fdx) = [];
    ekinox_gnss.h(idx:fdx)   = [];
    ekinox_gnss.vel(idx:fdx, :) = [];
    
    % GNSS OUTRAGE 2
    idx  = find(ekinox_gnss.t > tor2_min, 1, 'first' );
    fdx  = find(ekinox_gnss.t < tor2_max, 1, 'last' );
    
    ekinox_gnss.t(idx:fdx) = [];
    ekinox_gnss.lat(idx:fdx) = [];
    ekinox_gnss.lon(idx:fdx) = [];
    ekinox_gnss.h(idx:fdx)   = [];
    ekinox_gnss.vel(idx:fdx, :) = [];
end

%% Print navigation time

to = (ref.t(end) - ref.t(1));

fprintf('NaveGo: navigation time is %.2f minutes or %.2f seconds. \n', (to/60), to)

%% INS/GNSS integration

if strcmp(INS_GNSS, 'ON')
    
    fprintf('NaveGo: INS/GNSS integration... \n')
    
    % Execute INS/GPS integration
    % ---------------------------------------------------------------------
    nav_ekinox_or = ins_gnss(mpu6000_imu, ekinox_gnss, 'quaternion'); %
    % ---------------------------------------------------------------------
    
    save nav_ekinox_or.mat nav_ekinox_or
    
else
    
    load nav_ekinox_or
end

%% ANALYZE A CERTAIN PART OF THE INS/GNSS DATASET

% COMPLETE TRAJECTORY
tmin = 138000; % Entering PoliTo parking.
tmax = 139262; % Before entering tunnel

% OUTRAGE 1
% tmin = tor1_min;
% tmax = tor1_max; 

% OUTRAGE 2
% tmin = tor2_min;
% tmax = tor2_max; 

% Sincronize REF data to tmin and tmax
idx  = find(ref.t > tmin, 1, 'first' );
fdx  = find(ref.t < tmax, 1, 'last' );
if(isempty(idx) || isempty(fdx))
    error('ref: empty index')
end

ref.t       = ref.t    (idx:fdx);
ref.roll    = ref.roll (idx:fdx);
ref.pitch   = ref.pitch(idx:fdx);
ref.yaw     = ref.yaw  (idx:fdx);
ref.lat     = ref.lat  (idx:fdx);
ref.lon     = ref.lon  (idx:fdx);
ref.h       = ref.h    (idx:fdx);
ref.vel     = ref.vel  (idx:fdx, :);

%% Interpolate INS/GNSS dataset

% INS/GNSS estimates and GNSS data are interpolated according to the
% reference dataset.

[nav_ref,  ref_n] = navego_interpolation (nav_ekinox_or, ref);
[gnss_ref, ref_g] = navego_interpolation (ekinox_gnss,  ref);

%% Print navigation time

to = (ref.t(end) - ref.t(1));

fprintf('NaveGo: navigation time under analysis is %.2f minutes or %.2f seconds. \n', (to/60), to)

%% Print RMSE from INS/GNSS data

rmse_v = print_rmse (nav_ref, gnss_ref, ref_n, ref_g, 'Ekinox IMU/GNSS');

%% Save RMSE to CVS file

csvwrite('nav_ekinox_or.csv', rmse_v);

%% PLOT

if (strcmp(PLOT,'ON'))
    
    navego_plot (ref, ekinox_gnss, nav_ekinox_or, gnss_ref, nav_ref, ref_g, ref_n)
end
