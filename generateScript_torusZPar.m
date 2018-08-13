function generateScript_torusZPar(r, R)
%r = radius of the tube.
%R = distance from center of torus to center of tube.


filename = 'torusZ.gwl';
fid = fopen(filename,'w');
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

%Define laser power
power_pSiJ400_6_29_18 = [0,10,15,20,25,30,35,40,45,50,55,60,65,70,75];
n_pSiJ400_6_29_18 = [1.4263,1.472,1.536,1.645,1.675,1.71,1.863,1.945,1.95,1.96,1.975,1.987,1.98,2.05,1.99];
n = 1.863;
lp = interp1(n_pSiJ400_6_29_18, power_pSiJ400_6_29_18, n);

%General Variables
spacing = 0.1;
torusPoints;

pointsSortedSize = size(pointsSorted);
for i = 1 : 1 : pointsSortedSize(1)
    x0 = pointsSorted(i, 1);
    y0 = pointsSorted(i, 2);
    z0 = pointsSorted(i, 3);
    %x0, y0, z0 defines a point in the first octant.
    %The line is written to that points reflection across the y axis, which
    %is on the other side of the "tube" of the torus.
    xf = -x0;
    fprintf(fid, '%f %f %f %f \r\n', x0, y0, z0, lp);
    fprintf(fid, '%f %f %f %f \r\n', xf, y0, z0, lp);
    fprintf(fid, 'write \r\n \r\n');
end
fclose('all');


    function torusPoints
        %generates the points for the surface of the torus located in the
        %first octant (eigth of the torus overall) using parametric
        %equations for a torus.
        points = nan(1, 3);
        du = spacing / R;
        dv = spacing / r;
        %u is like what phi is in spherical. u = 0 is on the y-axis.
        %v is like theta in cylindrical, but centered at the center of the
        %tube for each given u.
        %
        
        %u determines the quadrant of the yz coordinate plane that the
        %point will be in.
        %QUADRANTS OF YZ-PLANE AS DETERMINED BY u.
        %0 < u < pi / 2 : first (top right)
        %pi / 2 < u < pi : fourth (bottom right)
        %pi < u < 3pi / 2 : third (bottom left)
        %3pi / 2 < u < 2pi : second (top left)
        
        %0 < v < pi restricts you to the positive side of the yz plane(we write
        %from that point to the other side.
        %
        for u = 0 : du : (2 * pi)
            for v = 0 : dv : pi
                x = r * sin(v);
                y = (R + (r * cos(v))) * sin(u); 
                z = (R + (r * cos(v))) * cos(u);
                point = [x y z];
                points = [points;point];
            end
        end
        sizeVector = size(points);
        rows = sizeVector(1);
        columns = sizeVector(2);
        pointsTrim = points(2 : rows, 1 : columns); %cut out first row of nans.
        %now trimSize has exactly all of the points for an eigth of a torus.
        pointsSorted = sortrows(pointsTrim, [3 2]);
    end
end

