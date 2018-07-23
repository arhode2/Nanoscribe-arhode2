function practiceTorus (rIn, rOut)
%File namer
if mod(rIn,1)~=0
    rInString = strrep(num2str(rIn),'.','p');
else
    rInString = num2str(rIn);
end
if mod(rOut,1)~=0
    rOutString = strrep(num2str(rOut),'.','p');
else
    rOutString = num2str(rOut);
end
filename = strcat('practiceTorus rIn',rInString,'um rOut',rOutString,'um.gwl');
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

writestring = strcat('WriteText "r = ' , rInString,' l = ', rOutString, '"\r\n');
fprintf(fid,writestring);

fprintf(fid,'FindInterfaceAt 20\r\n\r\n');

%Define laser power
power_pSiJ400_6_29_18 = [0,10,15,20,25,30,35,40,45,50,55,60,65,70,75];
n_pSiJ400_6_29_18 = [1.4263,1.472,1.536,1.645,1.675,1.71,1.863,1.945,1.95,1.96,1.975,1.987,1.98,2.05,1.99];
n = 1.863;
lp = interp1(n_pSiJ400_6_29_18, power_pSiJ400_6_29_18, n);

%General variables
spacing = 0.05; %um
vertOffset = 0;
%rIn as input
%rOut as input
rTor = (rOut - rIn) / 2;
rCenter = (rOut + rIn) / 2;
zMin = -rTor;
zMax = rTor;
thetaMin = 0;
thetaMax = 2 * pi;
dTheta = (2 * spacing) / rOut; %Use trig and small angle approximation


%Write the torus
for z = zMin : spacing : zMax
    l = sqrt(4 * (rTor^2 - z^2));
    for theta = thetaMin : dTheta : thetaMax
        xOriginNew = rCenter * cos(theta);
        yOriginNew = rCenter * sin(theta);
        x0 = xOriginNew - ((l / 2) * cos(theta));
        y0 = yOriginNew - ((l / 2) * sin(theta));
        xf = xOriginNew + ((l / 2) * cos(theta));
        yf = yOriginNew + ((l / 2) * sin(theta));
        
        fprintf(fid, '%f %f %f %f \r\n', x0, y0, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf, yf, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end
closed = fclose(fid);
close = fclose('all');
end