function force = interpolate(coords)
  % DATA POINTS
  vol = [.46 .5 .6  .75 1   1.5 2   2.5 3   3.5 4   4.5 5] * 113.14;
  % top half
  p1 =  [7   9   9.9 8   5.4 3.2 2.2 1.6 1.3 .9  .4  .35 .32] * 5.7;
  % bottom half
  p2 =  [7   5   3   2   1.4 .75 .55 .4  .37 .35 .3  .31 .32] * 5.7;

  % INTERPOLATION
  l = length(coords);
  p1i = interp1 (vol, p1, coords(1:l/2), "spline");
  p2i = interp1 (vol, p2, fliplr(coords(l/2+1:l)), "spline");
  
  force = [p1i fliplr(p2i)];
end