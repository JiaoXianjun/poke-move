function poke_move(lat, lon, start_minute, len_second)
% len_second at least 40s

start_minute = 0;
len_second = 40;
lat_lon_poi = [51.036629, 3.717257;
51.036740, 3.717858;
51.036848, 3.718695;
51.037513, 3.718792;
51.038134, 3.719232];

lat_lon_poi = [lat_lon_poi; lat_lon_poi((end-1):-1:2,:)];

while 1
  for i=1:size(lat_lon_poi,1)
    lat = lat_lon_poi(i,1);
    lon = lat_lon_poi(i,2);
    bin_gen_str = ['./gps-sdr-sim -e brdc0280.17n -l ' num2str(lat) ',' num2str(lon) ',8 -t 2017/01/28,2:' num2str(start_minute) ...
    ':00 -o gpssim-static.bin -d ' num2str(len_second)];

    disp(bin_gen_str); fflush(1);

    system(bin_gen_str);

    system('bladeRF-cli -s bladerf.script');
    
    %lat = lat + 0.0001;
    %lon = lon + 0.0001;
  %  lat = lat - 0.0003;
  %  lon = lon - 0.0003;
    start_minute = start_minute + 1;
  end
end
