%{

    TNM034 - Facial Recognition
    HT2017 - Link?ping University

    Process:
        1. Load image and color correct using Gray World Assumption
        2. Transform to YCbCr Color space
        3. Detect face and create face mask
        4. 

%}

%% Main 
clc;
clear;
close all;

% Read image from database
input = imread('images/DB1/db1_02.jpg');

% Color correct image
output = colorCorrection(input);
%output = refWhite(output);

%figure
%mshow(output);
%title('Color corrected');
tic
face = detectFace(output);
toc
figure
imshow(face);

%Eye positions
%[eyePos1, eyePos2] = eyeMap(output, faceMask);

%Mouth map and mouth position
%[mouthmap, mouthPos] = mouthMap(output);

%rotatedImage = face_orientation(output, eyePos1, eyePos2);

%Crop image
%eyeCenter = round((eyePos1 + eyePos2)./2);
%centerOfImage = round((eyeCenter + mouthPos)./2);

%xmin = centerOfImage(1) - 125;
%xmax = centerOfImage(1) + 125;
%ymin = centerOfImage(2) - 200;
%ymax = centerOfImage(2) + 150;

%width = xmax- xmin;
%height = ymax - ymin;
%cropped = imcrop(rotatedImage,[xmin ymin width height]);

%figure
%imshow(cropped)


%% Load images, run detection and create eigenfaces with PCA 

clc;
clear;
dirname = 'images/TestDB';
files = dir(fullfile(dirname, '*.jpg'));
files = {files.name}';

for i=1:numel(files)
    fname = fullfile(dirname, files{i});
    img = imread(fname);
    output = colorCorrection(img); % Color correct
    result = detectFace(output);   % Detect face
    %result = rgb2gray(output);          % TEMPORARY FOR TEST
    faces_db(:,:,i) = result;
end

numberofimages = numel(files);
disp(['Loaded ', num2str(numberofimages), ' faces successfully'])

[X,Y] = size(faces_db(:,:,1));
n = X*Y;
% Reshape images to vectors
faces_db = reshape(faces_db, [n, numberofimages]);

% Run PCA algorithm
x = double(faces_db);
meanImage = mean(x');                   % Find average face vector
A = bsxfun(@minus, x', mean(x'))';      % Subtract the mean for each vector in faces_db
C = transpose(A) * A;                   % Covariance matrix (MxM) 
[eigVec, eigVal] = eig(C);              % Eigenvectors and eigenvalues in smaller dimension
eigenVecLarge = A * eigVec;             % Eigenvectors in bigger dimension (n x n)

% Reshaping the n-dim eigenvectors into matrices (eigenfaces)
eigenfaces = [];
for k = 1:numberofimages
    c  = eigenVecLarge(:,k);
    eigenfaces{k} = reshape(c,X,Y);
end

x = diag(eigVal);
[xc,xci] = sort(x,'descend'); % get largest eigenvalue
z = [];
[xciR, xciC] = size(xci);
for e = 1:xciR
    z = [z, eigenfaces{xci(e)}];
end

figure
imshow(z,'Initialmagnification','fit')
title('eigenfaces')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%