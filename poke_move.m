function poke_move(lat, lon, start_minute, len_second)
% len_second at least 40s

for i=1:10
  bin_gen_str = ['./gps-sdr-sim -e brdc0280.17n -l ' num2str(lat) ',' num2str(lon) ',8 -t 2017/01/28,1:' num2str(start_minute) ...
  ':00 -o gpssim-static.bin -d ' num2str(len_second)];

  disp(bin_gen_str); fflush(1);

  system(bin_gen_str);

  system('bladeRF-cli -s bladerf.script');
  
  %lat = lat + 0.0001;
  %lon = lon + 0.0001;
  lat = lat - 0.0003;
  lon = lon - 0.0003;
  start_minute = start_minute + 1;
end

