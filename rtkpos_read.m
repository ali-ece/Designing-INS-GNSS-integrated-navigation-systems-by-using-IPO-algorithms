function gnss_data = rtkpos_read(fname)
% Ali Mohammadi_INS/GNSS

% rtkpos_read: reads RTKPOS output file and transforms it to NaveGo format.
%
% INPUT
%   fname: file name (string).
%
% OUTPUT
%   gnss_data: data structure with the following format:
%
%     week:   GPS week (integer).
%     t:      GPS time of week (TOW, s). 
%     lat:    latitude (rad). 
%     lon:    longitude (rad). 
%     h:      height (m).  
%     Q:      quality flag (Q=1:fix, 2:float, 3:sbas, 4:dgps, 5:single, 6:ppp). 
%     ns:     number of valid satellites (integer).
%     header: header of RTKPOS file.
%     freq:   GNSS frequency update (Hz).
%
%     sdn (m).  
%     sde (m).  
%     sdu (m). 
%     sdne (m). 
%     sdeu (m). 
%     sdun (m).
%
%       The estimated standard deviations of the solution assuming a priori 
%       error model and error parameters by the positioning options. The 
%       sdn, sde or sdu means N (north), E (east) or U (up) component of 
%       the standard deviations in m. The absolute value of sdne, sdeu or 
%       sdun means square root of the absolute value of NE, EU or UN 
%       component of the estimated covariance matrix. The sign represents 
%       the sign of the covariance. With all of the values, user can 
%       reconstruct the full covariance matrix. 
%
%     age (s). 
%
%       Age of differential. The time difference between the 
%       observation data epochs of the rover receiver and the base station. 
%
%     ratio:  ratio factor. 
%       
%       The ratio factor of ʺratio�?testʺ for standard 
%       integer ambiguity validation strategy. The value means the ratio of 
%       the squared sum of the residuals with the second best integer vector 
%       to with the best integer vector. 
%%

% RTKPOS format
% WWWW, GPST, latitude (deg), longitude (deg), height (m),  Q, ns,  sdn(m),  sde(m),  sdu(m), sdne(m), sdeu(m), sdun(m),age(s), ratio

D2R = pi/180;

%% OPEN FILE

fid = fopen(fname, 'r');
if fid == -1
    error('rtkpos_read: %s file not found', fname)
end


%% TOTAL NUMBER OF LINES

lines = nnz(fread(fid) == 10);
fprintf('rtkpos_read: %s file has %d lines. \n', fname, lines);

% Set pointer back to the beginning
fseek(fid,0,'bof');

%% HEADER

line = fgetl(fid);
hdlines = 0;

header = {};

while ( strtok(line) == '%' )
    
    hdlines = hdlines + 1;
    header(hdlines, :) = cellstr (line);
    line = fgetl(fid);
end

% Set pointer back to the beginning
fseek(fid,0,'bof');

fprintf('rtkpos_read: %s has %d headerlines. \n', fname, hdlines);

%% GNSS DATA

% Create pattern for textscan()
str = [];
for i=1:15
    
    str = [str '%f '] ;
end

% Load data in cell
data_cell = textscan(fid, str, 'Headerlines', hdlines);

data_m = cell2mat (data_cell);

gnss_data.week  = data_m(:,1);
gnss_data.t     = data_m(:,2);
gnss_data.lat   = data_m(:,3) * D2R;
gnss_data.lon   = data_m(:,4) * D2R;
gnss_data.h     = data_m(:,5);
gnss_data.Q     = data_m(:,6);
gnss_data.ns    = data_m(:,7);
gnss_data.sdn   = data_m(:,8);
gnss_data.sde   = data_m(:,9); 
gnss_data.sdu   = data_m(:,10); 
gnss_data.sdne  = data_m(:,11); 
gnss_data.sdeu  = data_m(:,12); 
gnss_data.sdun  = data_m(:,13);
gnss_data.age   = data_m(:,14); 
gnss_data.ratio = data_m(:,15);

dtg = median(diff(gnss_data.t));
gnss_data.freq = 1/dtg;

gnss_data.header =  header;

fclose(fid);

end
