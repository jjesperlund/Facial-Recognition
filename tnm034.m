function [ bestID ] = tnm034( image )
    % Check if face in im exists in database

    % Load pre-calculated eigenfaces and corresponding matrices
    load database;

    output = colorCorrection(image);    % Color correct
    face = detectFace(output);          % Detect face

    % Return if face could not get detected
    if isempty(face)
        id = -1;
        return
    end

    % Project detected face to eigenfaces space 
    [cols, rows] = size(face);
    dimensions = cols*rows;

    face = reshape(face, [1, dimensions]);
    face = im2double(face);
    face = face-meanImage;
    [w, h] = size(weights);
    numOfFacesInDB = w;

    % Calculate face weights vector
    for i = 1:numOfFacesInDB
        w =  transpose( eigenVecLarge(:,i) ) * transpose(face);
        faceWeights(i) = w;
    end    
    
    % Find the shortest distance weight vector
    %distance = abs(sum(faceWeights-weights, 2));
    for j = 1:numOfFacesInDB
        s = abs(sum(faceWeights) - sum(weights(:,j)));
        % Ta summan av en rad eller kolumn i weights?? 
        distance(j) = s;
    end
    
    % Sorted weight vector (decreasing)
    [weights, index] = sort(distance);  
    
    bestID = index(1)
    bestWeight = weights(1)
    
 
end

