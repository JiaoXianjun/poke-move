function [tmin, tmax] = probe_tmin_tmax_in_gps_fiel(gps_file)
exe_str = ['./gps-sdr-sim -l 30.286502,120.032669,100 -t 2000/01/01,23:59:59 -e' gps_file];
[~, str_return] = system(exe_str);

tmin_idx = strfind(str_return,'tmin');
tmax_idx = strfind(str_return,'tmax');

tmin_str = str_return(tmin_idx:(tmax_idx-1));
tmax_str = str_return(tmax_idx:end);

year = str2num(tmin_str(8:11));
month = str2num(tmin_str(13:14));
day = str2num(tmin_str(16:17));
hour = str2num(tmin_str(19:20));
minute = str2num(tmin_str(22:23));
second = str2num(tmin_str(25:26));

tmin = [year month day hour minute second];

year = str2num(tmax_str(8:11));
month = str2num(tmax_str(13:14));
day = str2num(tmax_str(16:17));
hour = str2num(tmax_str(19:20));
minute = str2num(tmax_str(22:23));
second = str2num(tmax_str(25:26));

tmax = [year month day hour minute second];
