# poke-move

Principle:

NASA GPS data --> gen_bladerf_bin script --> .bin, .script file --> bladeRF-cli --> bladeRF board --> antenna --> your cellphone (pokemon go)

0. Generate gps-sdr-sim from this project https://github.com/osqzss/gps-sdr-sim firstly if mine doesn't work for your computer.

1. Input gps latitude and lontitude pairs in lat_lon_poi_all.txt. You may make them as a close path.

2. In octave, run: gen_bladerf_bin('hour0630.17n','lat_lon_poi_all.txt', 130, 200);
    - 'hour0630.17n' data file downloaded from NASA. (See last note)
    - 110 -- stay duration of each gps location: 130s
    - 200 -- number of round. Each round will cover all points in the .txt.
    - This script generates .bin and .script files needed by bladeRF-cli

3. In linux shell, run: bladeRF-cli -s lat_lon_poi_all_130s.script (the .script is generated by the octave script)

Note: Download latest NASA satellite file (*.17n) here: (You should update this file from NASA frequently.)

ftp://cddis.gsfc.nasa.gov/gnss/data/hourly/

