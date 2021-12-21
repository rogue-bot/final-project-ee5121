%% Training

data_set = "gt_db";
folders_raw = {dir(data_set).name};
len = length(folders_raw);

% names in of the people (used to fetch image data)
names = {folders_raw{3:len}};
% number of images to be used for training
trian_images_no = 6 ;
rows_ = 50;
cols_ = 50;

test_sample_size = 6;
offset = 1;

% place holder cell array
X = {};

% for each person in the name list
for name = names
    % matrix Xi (empty at the start)
    
    Xi = Get_Class_Xi(data_set,name,trian_images_no,[rows_,cols_]);
    % add class of person to the class matrix X
    X{end+1} = Xi;
end



%%  prediction
classes = length(names);
close all;
clc;


accuracy = [];

for name = names
    temp_acc = 0;
    img_path = data_set +"\" + name + "\";
    folders_raw = {dir(img_path).name};
    len = length(folders_raw);
    imgs = {folders_raw{3:len}};
    
    for test_no = trian_images_no+offset : trian_images_no + test_sample_size+offset
        
        test_Xi = Get_Class_Xi(data_set,name,0,[rows_,cols_],test_no);

        % if the image is a test
        file_name = img_path+ "\" + string(imgs{test_no});


        test_image = imread(file_name);
        test_image2d = im2gray(test_image)';
        test_image2d = imresize(test_image2d,[rows_,cols_]);

        figure(1);
        imshow(test_image2d');
        title("Test Case Image ");

%         d is the distance vector (each element is the distance b\w y and y_hat)
        d = [];
        y_hat = {};
        for i = 1 : classes
 
                Xi  = double(X{i});
                y = double(test_Xi);
                % calculate beta

                beta = (Xi'*Xi) \ Xi' * y;

                % estimate y_hat
                y_hat = Xi*beta;
                % compute and add the distance to d vector
                d = [d norm(y-y_hat)];
            


            %y_hat_img = [];
            % y_hat_img = reshape(y_hat,[rows_,cols_]);
%            sub_img_size = Get_sub_img_size(hor_partition_no,rows_,cols_);
%             figure(i+1);
%             tiledlayout(hor_partition_no,2,'TileSpacing','compact');
%             for k = 1:subimg_no
%                 %subplot(hor_partition_no,2,k)
%                 nexttile
%                 imshow(reshape(uint8(y_hat{i}{k}),[sub_img_size{k}])')
%             end
%             sgtitle(['Reconstructed Image from class U',num2str(i),names(i)],'Interpreter', 'none');
        end

        % intermediate minimum
   
        [min_distance, class_pred] = min(d);
        % The element with least distance should be our prediction
        % [min_distance, index] = min(d);
        if name == string(names{class_pred})
            fprintf("%s is predicted correctly \n",string(name));
            temp_acc = temp_acc + 1;
        else
            fprintf("%s is predicted incorrectly as %s \n",string(name),string(names{class_pred}));
        end
        % temp_acc
        
    end
    accuracy = [accuracy temp_acc/(test_sample_size+1)];
end


accuracy
