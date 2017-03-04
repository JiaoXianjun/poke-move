function gen_bladerf_bin(gps_file,lat_lon_poi_filename, len_second, num_round)
% len_second at least 40s

%len_second = 60;
%lat_lon_poi = [51.036629, 3.717257;
%51.036740, 3.717858;
%51.036848, 3.718695;
%51.037513, 3.718792;
%51.038134, 3.719232];

%lat_lon_poi = [
%51.036335, 3.714795;
%51.035336, 3.716266;
%51.034992, 3.715418;
%51.035377, 3.714238;
%51.035782, 3.712993]

%num_col = 2;
%num_row = length(lat_lon_vec)/num_col;
%lat_lon_poi = reshape(lat_lon_vec,[num_col,num_row]).';
%
%lat_lon_poi = [lat_lon_poi; lat_lon_poi((end-1):-1:2,:)];

lat_lon_poi = load(lat_lon_poi_filename);

[tmin, tmax] = probe_tmin_tmax_in_gps_fiel(gps_file);
disp(['tmin ' num2str(tmin)]);
disp(['tmax ' num2str(tmax)]);

year = tmax(1);
month = tmax(2);
day = tmax(3);
h = tmax(4);
m = tmax(5);
s = tmax(6);

idx = find(lat_lon_poi_filename == '.');
if isempty(idx)
  main_name_lat_lon_poi_filename = lat_lon_poi_filename;
else
  main_name_lat_lon_poi_filename = lat_lon_poi_filename(1:(idx(end)-1));
end

script_filename = [main_name_lat_lon_poi_filename '_' num2str(len_second) 's.script'];
fid = fopen(script_filename,'w');
if fid == -1
  disp('fopen script_filename fail.');
  return;
end

start_s = hms2s(h, m, s) - len_second*(size(lat_lon_poi,1)+1);
disp(['len_second ' num2str(len_second) ' num poi ' num2str(size(lat_lon_poi,1)) ' second backoff ' num2str(len_second*(size(lat_lon_poi,1)+1))]);
for j=1:num_round
  for i=1:size(lat_lon_poi,1)
    lat = lat_lon_poi(i,1);
    lon = lat_lon_poi(i,2);
    bin_filename = ['gps_' num2str(lat,"%12.6f") '_' num2str(lon,"%12.6f") '_' num2str(len_second) 's_bladerf.bin'];
    disp([bin_filename ' ' script_filename]);
    
    if isempty(dir(bin_filename))
        disp('bladerf bin file NOT FOUND. generating...'); fflush(1);
        % generation bladerf bin and script files
        [h, m, s] = s2hms(start_s);
        disp(['h m s ' num2str([h m s])]);
        time_str = [num2str(year) '/' num2str(month) '/' num2str(day) ',' num2str(h) ':' num2str(m) ':' num2str(s)];
        bin_gen_str = ['./gps-sdr-sim -e ' gps_file ' -l ' num2str(lat,"%12.6f") ',' num2str(lon,"%12.6f") ',8 -t ' time_str ...
        ' -o ' bin_filename ' -d ' num2str(len_second)];

        disp(bin_gen_str); fflush(1);

        system(bin_gen_str);
    else
        disp('bladerf bin file     FOUND.'); fflush(1);
    end
    
    fprintf(fid, 'set frequency tx 1575.42M\nset samplerate 2.6M\nset bandwidth 2.5M\nset txvga1 -20\nset txvga2 0\ncal lms\ncal dc tx\ntx config file=%s format=bin\ntx start\ntx wait\n', bin_filename);

    start_s = start_s + len_second;
  end
end

fclose(fid);

