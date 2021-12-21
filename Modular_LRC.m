%% Training

% names in of the people (used to fetch image data)
names = ["alex", "angelo" , "cpi" , "david" , "felix" , "harun"];

% number of images to be used for training
trian_images_no = 60;
rows_ = 256;
cols_ = 256;
hor_partition_no = 2;

% place holder cell array
U = {};

% for each person in the name list
for name = names
    % matrix Xi (empty at the start)
    Ui = Get_Partioned_Class_Ui(name,trian_images_no,hor_partition_no,[rows_,cols_]);
    % add class of person to the class cell array U
    U{end+1} = Ui;
end



%%  prediction
classes = 6;

% take a test image and convert it into vector

test_U = Get_Partioned_Class_Ui("harun",0,hor_partition_no,[rows_,cols_],76);
subimg_no = 2*hor_partition_no;

% d is the distance vector (each element is the distance b\w y and y_hat)
d = {};
y_hat = {};
for i = 1 : classes
    Ui = U{i};
    d{i} = [];
    y_hat{i} = {};
    for j = 1:subimg_no
        % extract class matrix
        Xi = double(Ui{j});
        y = double(test_U{j});
        % calculate beta
        
        beta = inv(Xi'*Xi) * Xi' * y;
        
        % estimate y_hat
        y_hat{i}{j} = Xi*beta;
        % compute and add the distance to d vector
        d{i} = [d{i} norm(y-y_hat{i}{j})];
    end
    
    
    %y_hat_img = [];
    % y_hat_img = reshape(y_hat,[rows_,cols_]);
    sub_img_size = Get_sub_img_size(hor_partition_no,rows_,cols_);
    figure(i+1);
    tiledlayout(hor_partition_no,2,'TileSpacing','none');
    for k = 1:subimg_no
        %subplot(hor_partition_no,2,k)
        nexttile
        imshow(reshape(uint8(y_hat{i}{k}),[sub_img_size{k}])')
    end
    sgtitle(['Reconstructed Image from class U',num2str(i)]);
end

% The element with least distance should be our prediction
% [min_distance, index] = min(d);
% fprintf("our prediction is %s \n ",names(index));