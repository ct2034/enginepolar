function force = interpolate(coords)
  % DATA POINTS
  vol = [.46 .5 .6  .75 1   1.5 2   2.5 3   3.5 4   4.5 5] * 113.14;
  % top half
  p1 =  [7   9   9.9 8   5.4 3.2 2.2 1.6 1.3 .9  .4  .35 .32] * 5.7;
  % bottom half
  p2 =  [7   5   3   2   1.4 .75 .55 .4  .37 .35 .3  .31 .32] * 5.7;

  % STROKE -> VOL
  [av, ai] = max(coords);
  [iv, ii] = min(coords);
  Stroke = av - iv;
  Volume = max(vol) - min(vol);
  Cyl_Area = Volume / Stroke;
  Cyl_Diameter = sqrt(Cyl_Area / pi) * 2;
  
  % INTERPOLATION
  l = length(coords);
  coords = (max(coords)-coords)*Cyl_Area + min(vol);
  
  ai
  ii
  
  it = 1;
  ib = 1;
  if ai > ii
    top = 1;
  else
    top = 0;
  endif    
  
  for i = 1:length(coords) 
    if coords(i) == max(coords)
      top = 0;
    endif
    if coords(i) == min(coords)
      top = 1;
    endif
    % arrange 
    if top
      cortop(it) = coords(i);
      it += 1;
    else
      corbot(ib) = coords(i);
      ib += 1;
    endif
  endfor  
  
  if length(cortop) !=  length(corbot)
    disp 'index - ERROR'
  endif
  
  p1i = interp1 (vol, p1, cortop, "spline");
  p2i = interp1 (vol, p2, corbot, "spline");
  
  it = 1;
  ib = 1;
  if ai > ii
    top = 1;
  else
    top = 0;
  endif  
  
  for i = 1:length(coords) 
    if coords(i) == max(coords)
      top = 0;
    endif
    if coords(i) == min(coords)
      top = 1;
    endif
    % arrange 
    if top
      force(i) = p1i(it);
      it += 1;
    else
      force(i) = p2i(ib);
      ib += 1;
    endif
  endfor  
  
  it
  ib
  
  % figure;
  % plot(vol, p1, 'b');
  % hold on;
  % grid on;
  % plot(vol, p2, 'b');
  % legend(['data'; ' '; 'interpolated']);
  % plot(coords, force, 'r');
end