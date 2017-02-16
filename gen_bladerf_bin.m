function gen_bladerf_bin(gps_file,lat_lon_poi_filename, len_second, num_round)
% len_second at least 40s

start_h_m = [13 1];

start_minute = 0;
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

time_vec = clock;
time_vec(1) = 2017;
time_vec(2) = 2;
time_vec(3) = 6;
%h = time_vec(4);
%m = time_vec(5);
h = start_h_m(1);
m = start_h_m(2);
s = floor(time_vec(6));
%m_total = h*60+m;
%m_total = m_total - 120;
%h = floor(m_total/60);
%m = m_total - h*60;

script_filename = ['gps_' num2str(len_second) 's_bladerf_all.script'];
fid = fopen(script_filename,'w');
if fid == -1
  disp('fopen script_filename fail.');
  return;
end

start_minute = m;
for j=1:num_round
  for i=1:size(lat_lon_poi,1)
    lat = lat_lon_poi(i,1);
    lon = lat_lon_poi(i,2);
    bin_filename = ['gps_' num2str(lat,"%12.6f") '_' num2str(lon,"%12.6f") '_' num2str(len_second) 's_bladerf.bin'];
    disp([bin_filename ' ' script_filename]);
    
    if isempty(dir(bin_filename))
        disp('bladerf bin file NOT FOUND. generating...'); fflush(1);
        % generation bladerf bin and script files
        time_str = [num2str(time_vec(1)) '/' num2str(time_vec(2)) '/' num2str(time_vec(3)) ',' num2str(h) ':' num2str(start_minute) ':' num2str(s)];
        bin_gen_str = ['./gps-sdr-sim -e ' gps_file ' -l ' num2str(lat,"%12.6f") ',' num2str(lon,"%12.6f") ',8 -t ' time_str ...
        ' -o ' bin_filename ' -d ' num2str(len_second)];

        disp(bin_gen_str); fflush(1);

        system(bin_gen_str);
    else
        disp('bladerf bin file     FOUND.'); fflush(1);
    end
    
    fprintf(fid, 'set frequency tx 1575.42M\nset samplerate 2.6M\nset bandwidth 2.5M\nset txvga1 -15\nset txvga2 0\ncal lms\ncal dc tx\ntx config file=%s format=bin\ntx start\ntx wait\n', bin_filename);

    start_minute = start_minute + 1;
  end
end

fclose(fid);

