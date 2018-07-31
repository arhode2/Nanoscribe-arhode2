function generateScript_CylindricalTaper()
filename = 'CylindricalTaper.gwl';
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

%GeneralVaribles for entire function
lPart = 150; %um length of a segment. Full width section is one lPart, tapers may be different.
lTotal = 3 * lPart;
spacing = 0.05;
rThin = 1;
rThick = 5;

%General variables for 
vertOffset = 0;
xMin = 0;
zMin = -rThick;
zMax = rThick;

%Make the initial frustrum
for z = zMin : spacing : zMax
    y0 = -sqrt(rThick^2 - z^2);
    yf = sqrt(rThick^2 - z^2);
    for y = y0 : spacing : yf
        xf = -(lPart / (rThick - rThin)) * (sqrt(z^2 + y^2) - (rThick));
        if xf > lPart
            xf = lPart;
        end
        fprintf(fid, '%f %f %f %f \r\n', xMin, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');                                                                                                                                    
    end
end

%Make the cylinder
xOffset = lPart;
for z = zMin + (rThick - rThin) : spacing : zMin + rThick + rThin
    y0 = -sqrt(rThin^2 - z^2);
    yf = sqrt(rThin^2 - z^2);
    for y = y0 : spacing : yf
        fprintf(fid, '%f %f %f %f \r\n', xOffset, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', lPart + xOffset, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

%Make the ending frustrum
xOffset = 2 * lPart;
for z = zMin : spacing : zMax
    y0 = -sqrt(rThick^2 - z^2);
    yf = sqrt(rThick^2 - z^2);
    for y = y0 : spacing : yf
        x0 = (lPart / (rThick - rThin)) * (sqrt(z^2 + y^2) - rThin);
        fprintf(fid, '%f %f %f %f \r\n', x0 + xOffset, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', lPart + xOffset, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

closed = fclose(fid);
close = fclose('all');
end
