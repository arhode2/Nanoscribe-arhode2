function generateScript_metaLens(filename, d)
%Reads an image and generates a gwl using that image as an yz plane cross
%section. Lines are printed at a uniform depth in the x direction from the
%bottom up.

%{
Below is the image part.
%}

%filename as input

img = imread(filename);
R = img(:, :, 1);
G = img(:, :, 2);
B = img(:, :, 3);

%Currently this only works for a black and white image. That is, an image
%in which every pixel is either true black (0, 0, 0) or true white (255, 255, 255)
dim = size(img);
lpMap = nan(dim(1), dim(2));
for i = 1 : 1 : dim(1)
    for j = 1 : 1 : dim(2)
        if R(i, j) == 0 && G(i, j) == 0 && B(i, j) == 0
            %pixel is true black
            lpMap(i, j) = 0;
        elseif R(i, j) == 255 && G(i, j) == 255 && B(i, j) == 255
            %pixel is true white
            lpMap(i, j) = 1;
        end
    end
end



%{
Below is the nanoscribe part.
%}
filename = 'metaLens.gwl';
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


spacing = 0.1;
%d as input
lp = 0;
lp0 = 25; %input
lp1 = 75; %input

for i = 1 : 1 : dim(1)
    %fucking matlab indexes arrays starting at 1. what is this amateur
    %hour?
    z = (i - 1)* spacing;
    for j = 1 : 1 : dim(2)
        y = (j - 1) * spacing;
        if lpMap(i, j) == 0
            lp = lp0;
        else
            %at this point, lpMap contains only 0 and 1
            lp = lp1;
        end
        fprintf(fid, '%f %f %f %f \r\n', 0, y, z, lp);
        fprintf(fid, '%f %f %f %f \r\n', d, y, z, lp);
        fprintf(fid, 'write \r\n \r\n');
    end
end
fclose('all');
end

        


