function generateScript_torusZCartQuarterGRIN(rInput, RInput)
%rInput = radius of the tube.
%RInput = distance from center of torus to center of tube.



filename = 'torusZCartQuarterGRIN.gwl';
fid = fopen(filename,'w');
fprintf(fid,'PowerScaling 1.0\r\n');
fprintf(fid,'GalvoScanMode\r\n');
fprintf(fid,'ScanSpeed 40000\r\n');
fprintf(fid,'TextFontSize 5\r\n');

fprintf(fid,'ContinuousMode\r\n');

fprintf(fid,'StageGotoX 0\r\n');
fprintf(fid,'StageGotoY 0\r\n');

fprintf(fid,'FindInterfaceAt 0.5\r\n');
fprintf(fid,'TextFontSize 10\r\n');
fprintf(fid,'TextPositionX -60\r\n');
fprintf(fid,'TextPositionY 15\r\n');
fprintf(fid,'TextPositionZ 2\r\n');

%Define laser power
power_pSiJ400 = [0, 10, 25, 50]; %change final back to 30
n_pSiJ400 = [1.39, 1.4, 1.8, 2.0];
n = 0; %placeholder to initialize
lp = 0; %placeholder to initialize
nMin = min(n_pSiJ400);
nMax = max(n_pSiJ400);
delN = nMax - nMin;

%General Variables
spacing = 0.1;
pointsSorted = [];
pointsMaster = [];

for r = 0 : spacing : rInput
    torusPoints(r);
end

pointsMasterSorted = sortrows(pointsMaster, [3 2]); %originally [3 2]
disp(pointsMasterSorted);

pointsMasterSortedSize = size(pointsMasterSorted);
for i = 1 : 1 : pointsMasterSortedSize(1)
    x0 = pointsMasterSorted(i, 1);
    y0 = pointsMasterSorted(i, 2);
    z0 = pointsMasterSorted(i, 3);
    lp0 = pointsMasterSorted(i, 4);
    %x0, y0, z0 defines a point in the first octant.
    %The line is written to that points reflection across the y axis, which
    %is on the other side of the "tube" of the torus;
    fprintf(fid, '%f %f %f %f \r\n', x0, y0, z0, 30); %change 30 to lp0
    fprintf(fid, 'write \r\n \r\n');
end

fclose('all');


    function torusPoints(r)
        pointsSorted = [];
        realPoints = [];
        for z = -(RInput + r) : spacing : 0 %full torus is to RInput + rInput
            for y = -(RInput + r) : spacing : 0 %full torus is to RInput + rInput
                x = sqrt(r^2 - (RInput - sqrt(y^2 + z^2))^2);
                alpha = (delN / (2 * rInput));
                rScalar = abs(r / rInput);
                nGrin = nMax - (alpha * rScalar);
                lp = interp1(n_pSiJ400, power_pSiJ400, nGrin);
                point = [x y z lp];
                point2 = [-x y z lp];
                if imag(point(1)) == 0 && imag(point(2)) == 0 && imag(point(3)) == 0
                    realPoints = [realPoints;point];
                    realPoints = [realPoints; point2];
                end
            end
        end
        pointsSorted = sortrows(realPoints, [3 2]); %originally [3 2]
        pointsMaster = [pointsMaster; pointsSorted];
    end
end

