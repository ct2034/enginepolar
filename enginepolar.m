function img = enginepolar (V_a, CAs_i, F_max, F_min)
	% This is a simple 2-stroke engine design tool. It produces a polar plot of the crank torque per angle.
	close all
	%clear -exclusive V_a
	debug = 0;

	% defining variables
	%calc
	res = 1000; %points per revolution
	rad = [0:2*pi/res:2*pi]; %circular coordinate
	scale = 30	; % display scale for rodforce
	%forces
	%F_max = 1000; %N maximal force (at TDC)
	%F_min = 100;
	%geometry
	rod = .040; %m 
	stroke = .060; %m
	%V_a = 150; %deg V_angle
	PAs_i = [V_a/2 -V_a/2 V_a/2 -V_a/2 V_a/2 -V_a/2]; %deg Piston Angles
	%firing
	%CAs_i = [  0  60 240 300 120 180]; %deg Crank Angles
	%CAs_i = [  0   0   0   0   0   0]; %deg Crank Angles
	%CAs_i = [ 90  90  90  90  90  90]; %deg Crank Angles
	FAs_i = 90 + PAs_i - CAs_i; %deg Firing Angles

	FAs = FAs_i / 180*pi;
	CAs = CAs_i / 180*pi;
	PAs = PAs_i / 180*pi;


	% basic cos
	cosforce = @(angle) (F_max-F_min)/2.*cos(rad.-angle).+(F_max-F_min)/2+F_min;

	% piston force
	pistonforce = zeros(length(FAs), length(rad));
	for i = 1:length(FAs)
		pistonforce(i,:) = cosforce(FAs(i));
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

	i = 2;
	if debug
		plot ( rad*180/pi, pistonforce(i,:)/ 2);
		hold on;
		plot ( rad*180/pi, crankangle(i,:)* 180/pi, 'r' );
		plot ( rad*180/pi, rodangle(i,:)* 180/pi, 'g' );
		plot ( rad*180/pi, rodforce(i,:) / 2, 'm' );
		plot ( rad*180/pi, crankrodangle(i,:)* 180/pi, 'k' );
		hold off;
		legend('pistonforce', 'crankangle', 'rodangle', 'rodforce', 'crankrodangle');
		CH_save_plot();
	end

	% display
	figure(1, "visible", "off");
	disp off;
	polar(rad, sum(cranktorque))
	hold on;
	%polar(rad, 1/scale*sum(rodforce), 'r')
	%polar(rad, 1/scale*rodforce)

	axis equal;
	legend('Crank Torque (Nm)'); %, strcat(int2str(scale), '\1 * Rod Forces (N)'));
	title(strcat('Polar Plot == with FAs: ', mat2str(FAs_i), ', CAs: ', mat2str(CAs_i), ', Vangle: ', mat2str(V_a), ', min crank torque: ', mat2str(mincranktorque)));
	hold off;	
	img = CH_save_plot();
endfunction