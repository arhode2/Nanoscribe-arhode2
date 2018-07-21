function practicePrism(l, w, h)
%Nanoscribe prism written in the l direction
%l is the length in the x direction
%w is the length in the y direction
%h is the length in the z direction

%File namer
if mod(l,1)~=0
    lString = strrep(num2str(l),'.','p');
else
    lString = num2str(l);
end
if mod(w,1)~=0
    wString = strrep(num2str(w),'.','p');
else
    wString = num2str(w);
end
if mod(h,1)~=0
    hString = strrep(num2str(h),'.','p');
else
    hString = num2str(h);
end
filename = strcat('practicePrism l',lString,'um w',wString,'um h',hString,'um.gwl');
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

writestring = strcat('WriteText "l = ' , lString,' w = ', wString, ' h = ', hString, '"\r\n');
fprintf(fid,writestring);

fprintf(fid,'FindInterfaceAt 20\r\n\r\n');

%Define laser power
power_pSiJ400_6_29_18 = [0,10,15,20,25,30,35,40,45,50,55,60,65,70,75];
n_pSiJ400_6_29_18 = [1.4263,1.472,1.536,1.645,1.675,1.71,1.863,1.945,1.95,1.96,1.975,1.987,1.98,2.05,1.99];
n = 1.863;
lp = interp1(n_pSiJ400_6_29_18, power_pSiJ400_6_29_18, n);

%General variables
spacing = 0.05; %um

xMin = 0;
xMax = l;
yMin = 0;
yMax = w;
zMin = 0;
zMax = h;

vertOffset = 0; % um (dont need this for prism

%Make the prism
for z = zMin : spacing : zMax
    for y = yMin : spacing : yMax
        fprintf(fid, '%f %f %f %f \r\n', xMin, y, z + vertOffset, lp);
        fprintf(fid, '%f %f %f %f \r\n', xMax, y, z + vertOffset, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end

%Close the file
closed = fclose(fid);
close = fclose('all');
end

