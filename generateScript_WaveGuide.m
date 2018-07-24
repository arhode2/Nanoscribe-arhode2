function generateScript_WaveGuide(L, wIn, wOut)
%L is the distacne to write in x before moving the stage. Length of each
%segment

%w is the width of the waveguide in the center
%theta is the angle of tapering relative to the horizontal
% File Naming
%File namer
if mod(L,1)~=0
    LString = strrep(num2str(L),'.','p');
else
    LString = num2str(L);
end
if mod(wIn,1)~=0
    wInString = strrep(num2str(wIn),'.','p');
else
    wInString = num2str(wIn);
end
if mod(wOut,1)~=0
    wOutString = strrep(num2str(wOut),'.','p');
else
    wOutString = num2str(wOut);
end
filename = strcat('WaveGuide L',LString,'um wIn',wInString, 'um wOut',wOutString, 'um.gwl');
fid = fopen(filename,'w');

%NEED BEGINNING/STANDARD PARAMETERS
fprintf(fid,'TextFontSize 5\r\n');

fprintf(fid,'ContinuousMode\r\n');
fprintf(fid,'PowerScaling 1.0\r\n');
fprintf(fid,'GalvoScanMode\r\n');
fprintf(fid,'ScanSpeed 40000\r\n');

fprintf(fid,'StageGotoX 0\r\n');
fprintf(fid,'StageGotoY 0\r\n');

fprintf(fid,'FindInterfaceAt 0.5\r\n');
fprintf(fid,'TextFontSize 10\r\n');
fprintf(fid,'TextPositionX -60\r\n');
fprintf(fid,'TextPositionY 15\r\n');
fprintf(fid,'TextPositionZ 2\r\n');

%writestring = strcat('WriteText "L = ' , LString,' wIn= ', wInString, 'wOut =', wOutString, '"\r\n');
%fprintf(fid,writestring);

fprintf(fid,'FindInterfaceAt 20\r\n\r\n');

%Define laser power
power_pSiJ400_6_29_18 = [0,10,15,20,25,30,35,40,45,50,55,60,65,70,75];
n_pSiJ400_6_29_18 = [1.4263,1.472,1.536,1.645,1.675,1.71,1.863,1.945,1.95,1.96,1.975,1.987,1.98,2.05,1.99];
n = 1.863;
lp = interp1(n_pSiJ400_6_29_18, power_pSiJ400_6_29_18, n);

%General variables
spacing = 0.05; %um
vertOffset = 0;
xOffset = 0;
zMin = 0;
zMax = 1;
theta = tan(((wOut - wIn) / 2) / L);
disp(theta);

%Write the waveguide
TaperBegin=0;
TaperEnd=150;
slopeUp=(wIn/2-wOut/2)/(TaperEnd-TaperBegin);
slopeDown=(-wIn/2+wOut/2)/(TaperEnd-TaperBegin);

for z=zMin:spacing:zMax
    for y = - wOut / 2 : spacing : -wIn / 2
        xf = (y - (wIn / 2)) / slopeDown;
        fprintf(fid, '%f %f %f %f \r\n', (-(3 * L)) / 2, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
    for y = -wIn / 2 : spacing : wIn / 2
        fprintf(fid, '%f %f %f %f \r\n', (-(3 * L)) / 2, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', -(L / 2) + L, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
    for y = wIn / 2 : spacing : wOut / 2 
        xf = (y + (wIn / 2)) / slopeUp;
        fprintf(fid, '%f %f %f %f \r\n', (-(3 * L)) / 2, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

%Middle
xOffset = L / 2; %convert to moveStage later
yMin = -wIn / 2;
yMax = wIn / 2;
for z = zMin : spacing : zMax
    for y = yMin : spacing : yMax
        fprintf(fid, '%f %f %f %f \r\n', 0 + xOffset, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', L + xOffset, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

%Torus variables
rIn = 48;
rOut = 50;
spaceBetween = 2;

rTor = (rOut - rIn) / 2;
rCenter = (rOut + rIn) / 2;
zMin = -rTor;
zMax = rTor;
thetaMin = 0;
thetaMax = 2 * pi;
%dTheta = (2 * spacing) / rOut; Use trig and small angle approximation
dTheta = pi / 180;


%Write the torus
yOffset = rOut + spaceBetween;
for z = zMin : spacing : zMax
    l = sqrt(4 * (rTor^2 - z^2));
    for theta = thetaMin : dTheta : thetaMax
        xOriginNew = rCenter * cos(theta);
        yOriginNew = rCenter * sin(theta);
        x0 = xOriginNew - ((l / 2) * cos(theta));
        y0 = yOriginNew - ((l / 2) * sin(theta));
        xf = xOriginNew + ((l / 2) * cos(theta));
        yf = yOriginNew + ((l / 2) * sin(theta));
        
        fprintf(fid, '%f %f %f %f \r\n', x0, y0 + yOffset, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf, yf + yOffset, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

%end
xEnd = (3 * L) / 2;
for z=zMin:spacing:zMax
    for y = - wOut / 2 : spacing : -wIn / 2
        x0 = y / slopeUp;
        fprintf(fid, '%f %f %f %f \r\n', xEnd , y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', x0, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
    for y = -wIn / 2 : spacing : wIn / 2
        fprintf(fid, '%f %f %f %f \r\n', xEnd, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xOffset, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
    for y = wIn / 2 : spacing : wOut / 2 
        xf = (y + (wIn / 2)) / slopeDown;
        fprintf(fid, '%f %f %f %f \r\n', xEnd, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

closed = fclose(fid);
close = fclose('all');
end
