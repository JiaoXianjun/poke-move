function poke_ecef_csv_gen
%lat_lon = [
%51.036577, 3.716922;
%51.036590, 3.717035;
%51.036610, 3.717173;
%51.036644, 3.717398;
%51.036725, 3.717559;
%51.036738, 3.717709;
%51.036677, 3.717827;
%51.036589, 3.717806;
%51.036562, 3.718042;
%51.036562, 3.718246;
%51.036582, 3.718385;
%51.036595, 3.718578;
%51.036635, 3.718771;
%51.036675, 3.718943;
%51.036715, 3.719093;
%51.036843, 3.719072;
%51.036958, 3.718986;
%51.037154, 3.718943;
%51.037309, 3.718814;
%51.037471, 3.718760;
%51.037613, 3.718706;
%51.037775, 3.718760;
%51.037883, 3.718921;
%51.037890, 3.719038;
%51.038005, 3.719092;
%51.038120, 3.719178;
%51.038208, 3.719285;
%51.038255, 3.719414;
%51.038363, 3.719435;
%51.038471, 3.719424;
%51.038606, 3.719456;
%51.038754, 3.719595;
%51.038835, 3.719799;
%51.039037, 3.720035;
%51.039131, 3.720207;
%51.039144, 3.720443;
%51.039181, 3.720725;
%51.039201, 3.720959;
%51.039198, 3.721125;
%51.039303, 3.721125;
%51.039384, 3.721093;
%51.039502, 3.721023;
%51.039613, 3.720943;
%51.039677, 3.720879;
%51.039674, 3.720723;
%51.039701, 3.720610;
%51.039731, 3.720524;
%51.039782, 3.720449;
%51.039779, 3.720385;
%51.039759, 3.720326];

lat_lon = [
kron(ones(25,1),[51.036711, 3.718725]);
kron(ones(25,1),[51.036848,3.718781])];

alt = [linspace(8,8.5,10).'; linspace(8.5,8.7,20).'; linspace(8.7,8.2,10).';linspace(8.2,7.5,10).'];
lat_lon_alt = [lat_lon, alt];
lat_lon_alt = [lat_lon_alt;lat_lon_alt(end:-1:1,:)];

%lat_lon_alt = lat_lon_alt + rand(100,3)./(10^5);

lat_lon_alt_interp = zeros(3000, 4);
lat_lon_alt_interp(:,1) = (0:0.1:299.9).';
lat_lon_alt_interp(:,2) = interp1(0:(101/100):100, lat_lon_alt(:,1), 0:(1/30):(2999/30));
lat_lon_alt_interp(:,3) = interp1(0:(101/100):100, lat_lon_alt(:,2), 0:(1/30):(2999/30));
lat_lon_alt_interp(:,4) = interp1(0:(101/100):100, lat_lon_alt(:,3), 0:(1/30):(2999/30));

ecef = zeros(3000, 4);
ecef(:,1) = lat_lon_alt_interp(:,1);
for i=1:3000
  lat = lat_lon_alt_interp(i,2);
  lon = lat_lon_alt_interp(i,3);
  alt = lat_lon_alt_interp(i,4);
  [x,y,z] = lla2ecef(lat,lon,alt);
  ecef(i,2) = x;
  ecef(i,3) = y;
  ecef(i,4) = z;
end

csvwrite("poke_gent.csv",ecef);
plot(ecef(:,2));
  
% LLA2ECEF - convert latitude, longitude, and altitude to
%            earth-centered, earth-fixed (ECEF) cartesian
% 
% USAGE:
% [x,y,z] = lla2ecef(lat,lon,alt)
% 
% x = ECEF X-coordinate (m)
% y = ECEF Y-coordinate (m)
% z = ECEF Z-coordinate (m)
% lat = geodetic latitude (radians)
% lon = longitude (radians)
% alt = height above WGS84 ellipsoid (m)
% 
% Notes: This function assumes the WGS84 model.
%        Latitude is customary geodetic (not geocentric).
% 
% Source: "Department of Defense World Geodetic System 1984"
%         Page 4-4
%         National Imagery and Mapping Agency
%         Last updated June, 2004
%         NIMA TR8350.2
% 
% Michael Kleder, July 2005

function [x,y,z]=lla2ecef(lat,lon,alt)

% WGS84 ellipsoid constants:
a = 6378137;
e = 8.1819190842622e-2;

% intermediate calculation
% (prime vertical radius of curvature)
N = a ./ sqrt(1 - e^2 .* sin(lat).^2);

% results:
x = (N+alt) .* cos(lat) .* cos(lon);
y = (N+alt) .* cos(lat) .* sin(lon);
z = ((1-e^2) .* N + alt) .* sin(lat);

return