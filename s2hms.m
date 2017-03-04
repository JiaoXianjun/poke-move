function [h, m, s] = s2hms(a)
h = floor(a/3600);
m = floor((a - h*3600)/60);
s = a - h*3600 - m*60;
