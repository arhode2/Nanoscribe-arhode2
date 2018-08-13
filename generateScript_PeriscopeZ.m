function generateScript_PeriscopeZ(r, R, L)
%r is the radius of the cylindrical part, and the lesser radius of the
%torus.
%R is the greater radius of the torus, from center of hole to center of
%tube. In this case it's the radius of curvature.
%L is the length of one cylindrical segment.

%The final structure will have 
%   length 2L + 2R (y direction)
%   height L + 2R + 2r (z direction)
%   depth of 2r (x direction)
%Each direction is centered at the origin


filename = 'PeriscopeZ.gwl';
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
spacing = 0.1;
zOffset = 0;
yOffset = 0;
xOffset = 0;

%Initial forward cylinder
yOffset = - (L + R);
zOffset = -(R + (L / 2));
for z = - r : spacing : r
    x0 = -sqrt(r^2 - z^2);
    xf = sqrt(r^2 - z^2);
    for x = x0 : spacing : xf
        fprintf(fid, '%f %f %f %f \r\n', x + xOffset, yOffset, z + zOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', x + xOffset, L + yOffset, z + zOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

%first upward curve
yOffset = -R;
zOffset = -(L / 2);
torusPoints(pi / 2, pi);
pointsSortedSize = size(pointsSorted);
torusPart();

%vertical cylinder (stack of circles)
yOffset = 0;
zOffset = -(L / 2);
for z = 0 : spacing : L
    for y = -r : spacing : r
        x0 = -sqrt(r^2 - y^2);
        xf = sqrt(r^2 - y^2);
        fprintf(fid, '%f %f %f %f \r\n', x0 + xOffset, y + yOffset, z + zOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xf + xOffset, y + yOffset, z + zOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
        
    end
end

%Curve from upward to forward
zOffset = (L / 2);
yOffset = R;
torusPoints((3 * pi) / 2, 2 * pi);
pointsSortedSize = size(pointsSorted);
torusPart();

%Final forward cylinder
yOffset = R;
zOffset = R + (L / 2);
for z = - r : spacing : r
    x0 = -sqrt(r^2 - z^2);
    xf = sqrt(r^2 - z^2);
    for x = x0 : spacing : xf
        fprintf(fid, '%f %f %f %f \r\n', x + xOffset, yOffset, z + zOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', x + xOffset, L + yOffset, z + zOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

closed = fclose(fid);
close = fclose('all');


%Helper functions.
    function torusPoints(uMin, uMax)
        %generates the points for the surface of the torus located in the
        %first octant (eigth of the torus overall) using parametric
        %equations for a torus.
        points = nan(1, 3);
        du = spacing / R;
        dv = spacing / r;
        %u is like what phi is in spherical, but u=0 is on the x axis
        %v is like theta in cylindrical, but centered at the center of the
        %tube for each given u.
        for u = uMin : du : uMax
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
    function torusPart()
        pointsSortedSize = size(pointsSorted);
        for i = 1 : 1 : pointsSortedSize(1)
            x0 = pointsSorted(i, 1);
            y0 = pointsSorted(i, 2);
            z0 = pointsSorted(i, 3);
            %x0, y0, z0 defines a point in the first octant.
            %The line is written to that points reflection across the y axis, which
            %is on the other side of the "tube" of the torus.
            xf = -x0;
            fprintf(fid, '%f %f %f %f \r\n', x0 + xOffset, y0 + yOffset, z0 + zOffset, lp);
            fprintf(fid, '%f %f %f %f \r\n', xf + xOffset, y0 + yOffset, z0 + zOffset, lp);
            fprintf(fid, 'write \r\n \r\n');
        end
    end
        
end
