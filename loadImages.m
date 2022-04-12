% Haozhe Tian, CSP (EE4/MSc), 2021, Imperial College.
% Dec, 19th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display user images and find the largest number of pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% filepath (String) = File path containing three user images
% str1 (String) = file name of user 1's image
% str2 (String) = file name of user 2's image
% str3 (String) = file name of user 3's image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% im_1 (x1*y1*3 Uint8) = First image data
% im_2 (x2*y2*3 Uint8) = Second image data
% im_3 (x3*y3*3 Uint8) = Third image data
% P (Int) = maximum number of pixels of the three images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [im_1, im_2, im_3, P] = loadImages(filepath, str1, str2, str3)
%% Read in images
im_1 = imread(strcat(filepath, '/', str1));
im_2 = imread(strcat(filepath, '/', str2));
im_3 = imread(strcat(filepath, '/', str3));
%% Find maximum number of pixels
[x1,y1,~] = size(im_1);
[x2,y2,~] = size(im_2);
[x3,y3,~] = size(im_3);
Q1 = x1*y1*3*8;
Q2 = x2*y2*3*8;
Q3 = x3*y3*3*8;
P = max([Q1,Q2,Q3]);
%% Display images
h = figure();
h.Position = [100,100,700,200];
subplot(1,3,1);
imshow(im_1);
title('Image from Source One');  
subplot(1,3,2);
imshow(im_2);
title('Image from Source Two');  
subplot(1,3,3);
imshow(im_3);
title('Image from Source Three'); 
end

