%% Training

% names in of the people (used to fetch image data)
names = ["alex", "angelo" , "cpi" , "david" , "felix" , "harun"];

% number of images to be used for training
trian_images_no = 60;
rows_ = 256;
cols_ = 256;

% place holder matrix 
X = zeros(rows_*cols_, trian_images_no);

% for each person in the name list
for name = names
    % matrix Xi (empty at the start)
    Xi = Get_Class_Xi(name,trian_images_no,[rows_,cols_]);
    % add class of person to the class matrix X
    X = cat(3,X,Xi);
end
% remove place holder (zero matrix)
X = double(X(:,:,2:7));


%%  prediction
classes = 6;

% take a test image and convert it into vector
test_image = imread("face_data\harun\78.png");
test_image2d = rgb2gray(test_image)';
test_image2d = imresize(test_image2d,[rows_,cols_]);

figure(1);
imshow(test_image2d');
title("Test Case Image ");

test_image_col = [];
[m,n] = size(test_image2d);
for i = 1: n
    test_image_col = [test_image_col;test_image2d(:,i)];
    
end

y = double(test_image_col);

% d is the distance vector (each element is the distance b\w y and y_hat)
d = [];
for i = 1 : classes
    % extract class matrix
    Xi = X(:,:,i);
    % calculate beta
    
    beta = inv(Xi'*Xi) *Xi' * y;

    % estimate y_hat
    y_hat = Xi*beta;
    % compute and add the distance to d vector
    d = [d norm(y-y_hat)];
    
    %y_hat_img = [];
    y_hat_img = reshape(y_hat,[rows_,cols_]);

    figure(i+1);
    imshow(uint8(y_hat_img)');
    title(['Reconstructed Image from class X',num2str(i)]);
end

% The element with least distance should be our prediction
[min_distance, index] = min(d);
fprintf("our prediction is %s \n ",names(index));