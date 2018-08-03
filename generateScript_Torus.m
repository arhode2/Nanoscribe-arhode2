function generateScript_Torus()
filename = 'Torus.gwl';
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

fprintf(fid,'FindInterfaceAt 20\r\n\r\n');

%Define laser power
power_pSiJ400_6_29_18 = [0,10,15,20,25,30,35,40,45,50,55,60,65,70,75];
n_pSiJ400_6_29_18 = [1.4263,1.472,1.536,1.645,1.675,1.71,1.863,1.945,1.95,1.96,1.975,1.987,1.98,2.05,1.99];
n = 1.863;
lp = interp1(n_pSiJ400_6_29_18, power_pSiJ400_6_29_18, n);

%General Variables
rHole = 10;
rTor = 2;

rOut = rHole + (2 * rTor);
rIn = rHole;
rMid = rHole + rTor;

spacing = 0.1;
vertOffset = 0;
yOffset = 0;
xOffset = 0;
dTheta = pi / 90;
dPhi = pi / 90; 
thetaMax = atan(rTor / (rHole + rTor));
for z = -rOut : spacing : 0
    yf = sqrt(rTor^2 - (z + rMid)^2);
    for y = 0 : spacing : yf
        if z < -rIn
            x0 = 0;
        else
            x0 = sqrt(rIn^2 - y^2);
        end
        xf = sqrt(rOut^2 - y^2);
        fprintf(fid, '%f %f %f %f \r\n', x0 + xOffset, y + yOffset, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf + xOffset, y + yOffset, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

closed = fclose(fid);
close = fclose('all');
end