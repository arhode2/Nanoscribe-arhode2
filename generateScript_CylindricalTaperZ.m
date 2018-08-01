function generateScript_CylindricalTaperZ(rThick, rThin, lPart, num)
%rThick is the radius of the initial and final cylinders as well as the
%thick part of wave guide

%rThin is the radius of the thin part (middle) of the waveguide

%lPart is the length of the thin part of the waveguide.
%The total waveguide is 3 * lPart long, as is each cylinder.

%n is the number of cylinders before and after the waveguide.


filename = 'CylindricalTaperZ.gwl';
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

%rThick = 5 as input
%rThin = 1 as input
%lPart = 150; %um length of a segment. Full width section is one lPart, tapers may be different.
lTotal = 3 * lPart;
lHalf = lTotal / 2;
spacing = 0.1;
 
xMin = 0;
zMin = -rThick;
zMax = rThick;

vertOffset = 0;
xOffsetBeg = -lTotal / 2;
xOffsetEnd = lPart / 2;

%Write the initial n cylinders with radius rThick

%moveStageX = n moves the stage. The origin comes with it.
%num = 3; as input
fprintf(fid, 'moveStageX ');
fprintf(fid, '%f \r\n \r\n', -lTotal * (num + 1));
for i = num : -1 : 1
    fprintf(fid, 'moveStageX ');
    fprintf(fid, '%f \r\n', lTotal);
    for z = zMin : spacing : zMax
        y0 = -sqrt(rThick^2 - z^2);
        yf = sqrt(rThick^2 - z^2);
        for y = y0 : spacing : yf
            fprintf(fid, '%f %f %f %f \r\n', -lHalf, y, z + vertOffset, lp);
            fprintf(fid, '%f %f %f %f \r\n', lHalf, y, z + vertOffset, lp);
            fprintf(fid, 'write \r\n \r\n');
        end
    end
end

fprintf(fid, 'moveStageX ');
fprintf(fid, '%f \r\n \r\n', lTotal);
%Write the fucking waveguide
for z = zMin : spacing : zMax
    y0 = -sqrt(rThick^2 - z^2);
    yf = sqrt(rThick^2 - z^2);
    for y = y0 : spacing : yf
        if sqrt(y^2 + z^2) > rThin^2
            %Write the frustrums
            xfa = -(lPart / (rThick - rThin)) * (sqrt(z^2 + y^2) - (rThick));
            if xfa > lPart
                xfa = lPart;
            end
            %Initial Taper
            fprintf(fid, '%f %f %f %f \r\n', xMin + xOffsetBeg, y, z + vertOffset, lp);
            fprintf(fid, '%f %f %f %f \r\n', xfa + xOffsetBeg, y, z + vertOffset, lp);
            fprintf(fid, 'write \r\n \r\n');
        
            %Ending taper
            x0b = (lPart / (rThick - rThin)) * (sqrt(z^2 + y^2) - rThin);
            fprintf(fid, '%f %f %f %f \r\n', x0b + xOffsetEnd, y, z + vertOffset, lp);
            fprintf(fid, '%f %f %f %f \r\n', lPart + xOffsetEnd, y, z + vertOffset, lp);
            fprintf(fid, 'write \r\n \r\n');
        else
            %Write the cylinder extended through the frustrums
            fprintf(fid, '%f %f %f %f \r\n', xMin + xOffsetBeg, y, z + vertOffset, lp);
            fprintf(fid, '%f %f %f %f \r\n', lTotal + xOffsetBeg, y, z + vertOffset, lp);
            fprintf(fid, 'write \r\n \r\n');
        end
    end
end


%Ending cylinders
for i = 1 : 1 : num
    fprintf(fid, 'moveStageX ');
    fprintf(fid, '%f \r\n \r\n', lTotal);
    for z = zMin : spacing : zMax
        y0 = -sqrt(rThick^2 - z^2);
        yf = sqrt(rThick^2 - z^2);
        for y = y0 : spacing : yf
            fprintf(fid, '%f %f %f %f \r\n', -lHalf, y, z + vertOffset, lp);
            fprintf(fid, '%f %f %f %f \r\n', lHalf, y, z + vertOffset, lp);
            fprintf(fid, 'write \r\n \r\n');
        end
    end
end

closed = fclose(fid);
close = fclose('all');
end