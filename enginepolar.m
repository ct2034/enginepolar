%function img = enginepolar (V_a, CAs_i, F_max, F_min)
% This is a simple 2-stroke engine design tool. It produces a polar plot of the crank torque per angle.
close all
clear all
debug = 1;

% defining variables
%calc
res = 500; %points per revolution
d = 2*pi/res;
rad = [0:d:2*pi-d]; %circular coordinate
scale = 30	; % display scale for rodforce
%forces
F_max = 1000; %N maximal force (at TDC)
F_min = 100;
%geometry
rod = .040; %m 
stroke = .060; %m
V_a = 180; %deg V_angle
PAs_i = [V_a/2 -V_a/2 V_a/2 -V_a/2 V_a/2 -V_a/2]; %deg Piston Angles
strokeAtTDC = rod + stroke/2
%firing
CAs_i = [  0  60 240 300 120 180]; %deg Crank Angles
%CAs_i = [  0   0   0   0   0   0]; %deg Crank Angles
%CAs_i = [ 90  90  90  90  90  90]; %deg Crank Angles
FAs_i = PAs_i - CAs_i + 90; %deg Firing Angles

FAs_i = modulo(FAs_i)
CAs_i = modulo(CAs_i)
PAs_i = modulo(PAs_i)

FAs = FAs_i / 180*pi;
CAs = CAs_i / 180*pi;
PAs = PAs_i / 180*pi;

% piston force\	
pistonforce       = zeros(length(FAs), length(rad));
strokePerRotation = zeros(length(FAs), length(rad));
onehalf           = zeros(length(FAs), length(rad));
width             = zeros(length(FAs), length(rad));
twohalf           = zeros(length(FAs), length(rad));
for i = 1:length(FAs)
  onehalf(i,:) = stroke/2 * cos(CAs(i) - rad);
  width(i,:) = stroke/2 * sin(CAs(i) - rad);
  twohalf(i,:) = sqrt(rod**2 - width(i,:).**2);
  strokePerRad(i,:) = strokeAtTDC .- onehalf(i,:) .- twohalf(i,:);
  pistonforce(i,:) = interpolate(strokePerRad(i,:));
end

for i = 1:length(FAs)
  pistonforce(i,:) = rad;
end

%crank angle
crankangle = zeros(length(FAs), length(rad));
for i = 1:length(FAs)
  crankangle(i,:) = rad + CAs(i) - PAs(i);
  crankangle(i,:) = mod(crankangle(i,:), 2*pi);
end

%rod angle
rodangle = zeros(length(FAs), length(rad));
for i = 1:length(FAs)
  rodangle(i,:) = asin(stroke/2/rod * sin(crankangle(i,:)));
end

%rod force
rodforce = pistonforce .* cos(rodangle);

%crank rod angle
crankrodangle = zeros(length(FAs), length(rad));
for i = 1:length(FAs)
  crankrodangle(i,:) = pi - crankangle(i,:) - rodangle(i,:);
end

% crank torque
cranktorque = rodforce .* stroke/2 .* sin(crankrodangle);

% offset
mincranktorque = min( sum( cranktorque ) );

min( min( strokePerRad ) )
max( max( strokePerRad ) )

i = 2;
if debug
  plot ( rad*180/pi, pistonforce(i,:)/ 2);
  hold on;
  plot ( rad*180/pi, crankangle(i,:)* 180/pi, 'r' );
  plot ( rad*180/pi, rodangle(i,:)* 180/pi, 'g' );
  plot ( rad*180/pi, rodforce(i,:) / 2, 'm' );
  %plot ( rad*180/pi, crankrodangle(i,:)* 180/pi, 'k' );
  plot ( rad*180/pi, 10 * strokePerRad(i,:)* 180/pi, 'k' );
  hold off;
  legend('pistonforce', 'crankangle', 'rodangle', 'rodforce', 'strokePerRad');
  CH_save_plot();
end

% display
figure('Position',[100,100,1000,700]);                                                                                                                                          
subplot('Position',[.1 .1 .6 .8]);
%disp off;
polar(rad, sum(cranktorque))
grid on;
hold on;
%polar(rad, 1/scale*sum(rodforce), 'r')
%polar(rad, 1/scale*rodforce)

axis equal;                            
%legend('Crank Torque (Nm)'); %, strcat(int2str(scale), '\1 * Rod Forces (N)'));
title('Crank Torque (Nm)');
xy = max(sum(cranktorque))
text (1.05*xy,  .2*xy, strcat('FAs: ', mat2str(FAs_i))); 
text (1.05*xy,  .1*xy, strcat("CAs: ", mat2str(CAs_i))); 
text (1.05*xy,  .0*xy, strcat("Vangle: ", mat2str(V_a))); 
text (1.05*xy, -.1*xy, strcat("min crank torque: ", substr(mat2str(min(sum(cranktorque))), 1, 5))); 
text (1.05*xy, -.2*xy, strcat("max crank torque: ", substr(mat2str(max(sum(cranktorque))), 1, 5)));
hold off;	
img = CH_save_plot();