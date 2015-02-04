function out = modulo (angles)
  n = length(angles);
  out = zeros(1, n);
  for i = [1:n]
    if angles(i) < 0
      out(i) = 360 + angles(i);
    else
      out(i) = angles(i);
    endif
    out(i) = mod(out(i), 360); 
  endfor
endfunction