% Haozhe Tian, GROUP (EE4/MSc), 2021, Imperial College.
% Dec, 11th, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display the received image by converting bits back into R, B and G
% matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitsIn (Px1 Integers) = P demodulated bits of 1's and 0's
% Q (Integer) = Number of bits in the image (8 bit image has 256 grey levels)
% x (Integer) = Number of pixels in image in x dimension
% y (Integer) = Number of pixels in image in y dimension
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fImageSink(bitsIn,Q,x,y)

    bitsIn = bitsIn(1:Q*x*y*3); % Take valid pixels
    % Let each column represent a value between 0 and 256
    bitsIn = reshape(bitsIn, Q, floor(length(bitsIn)/Q));
    %initialize result image
    image = zeros(1, x*y*3);
    %turn binaries into decimals
    for i = 1 : x*y*3
        image(i) = bin2dec(sprintf('%d',(bitsIn(:,i)')));
    end
    image = reshape(uint8(image),x,y,3);
    % display image
    h = figure(); h.Position = [400,400,300,300];
    imshow(image)
    title('Received image');
    
end