
close all;
clear all;

% DATA POINTS
vol = [.46 .5 .6  .75 1   1.5 2   2.5 3   3.5 4   4.5 5] * 113.14;
% top half
p1 =  [7   9   9.9 8   5.4 3.2 2.2 1.6 1.3 .9  .4  .35 .32] * 5.7;
% bottom half
p2 =  [7   5   3   2   1.4 .75 .55 .4  .37 .35 .3  .31 .32] * 5.7;
res = 100;
  
voli = [min(vol):(max(vol)-min(vol))/res:max(vol)];
p = interpolate([voli fliplr(voli)]);

plot(vol, p1, 'b');
hold on;
grid on;
plot(vol, p2, 'b');
plot([voli fliplr(voli)], p, 'r');
legend(['data'; ' '; 'interpolated']);
