function generateScript_cryptoLens(filename)
%First take the image of the lens and resize it s.t. (dimmension in pixels)
%* spacing = (dimmension in um)
%reads from an image file
img = imread(filename);
triple = img(25, 85, :); %Manually find a red pixel
R = img(:, :, 1);
G = img(:, :, 2);
B = img(:, :, 3);
sizeVector = size(img);


%now we read binary to draw the lasers.
filename = 'cryptoLens.gwl';
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


spacing = 0.05;
h = 5; %h and w given in crypto lens parameters.
w = 17;
d = 5; %arbitrary for now, not sure what this is supposed to be.
lp = 0;
hPix = sizeVector(1);
wPix = sizeVector(2);

hScalar = h / hPix; %um per pixel
wScalar = w / wPix;

nRed = 2.0146;
nBlue = 1.4507; %Might just be background eventually.

%Define laser power
power_pSiJ400_6_29_18 = [0,10,15,20,25,30,35,40,45,50,55,60,65,70,75];
n_pSiJ400_6_29_18 = [1.4263,1.472,1.536,1.645,1.675,1.71,1.863,1.945,1.95,1.96,1.975,1.987,1.98,2.05,1.99];
lp0 = interp1(n_pSiJ400_6_29_18, power_pSiJ400_6_29_18, nBlue); %currently not used. Blue is just background.
lp1 = interp1(n_pSiJ400_6_29_18, power_pSiJ400_6_29_18, nRed);

colorError = 10; %amount over or under true red an RGB value can be to still be written.

%Looping weirdness is due to canvas coordinates weirdness. (0,0) is in the
%top left corner. Y increases from left to right. Z increases from top to
%bottom.
for i = hPix : -1 : 1
    z = (hPix - i) * spacing;
    for j = 1 : 1 : wPix
        y = (j - 1) * spacing;
        if ((triple(1) - colorError) < img(i, j, 1) && img(i, j, 1) < (triple(1) + colorError)) && ((triple(2) - colorError) < img(i, j, 2) && img(i, j, 2) < (triple(2) + colorError)) && ((triple(3) - colorError) < img(i, j, 3) && img(i, j, 3) < (triple(3) + colorError))
            fprintf(fid, '%f %f %f %f \r\n', 0, y, z, lp1);
            fprintf(fid, '%f %f %f %f \r\n', d, y, z, lp1);
            fprintf(fid, 'write \r\n \r\n');
        end
    end
end

fclose('all');
end
