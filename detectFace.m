function [ facemask ] = detectFace( input )
% Detecting face by creating binary face mask
% Adding face mask to input image
% Morphing the resulting image

height = size(input,1);
width = size(input,2);

%Initialize the output images
binary = zeros(height,width);

%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(input);
Y = img_ycbcr(:,:,1);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

%Detect Skin
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
numind = size(r,1);

% Mark skin pixels as white
for i=1:numind
    binary(r(i),c(i)) = 1;
end

%figure
%imshow(binary)
%title('binary face mask without morphing')

morphedBinary = enhanceFacemask(binary);

binary_uint8 = im2uint8(morphedBinary);

facemaskR = immultiply(input(:,:,1), binary_uint8/255);
facemaskG = immultiply(input(:,:,2), binary_uint8/255);
facemaskB = immultiply(input(:,:,3), binary_uint8/255);

facemask = cat(3, facemaskR, facemaskG, facemaskB);

end

