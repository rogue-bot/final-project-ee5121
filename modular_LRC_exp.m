%% Training

% names in of the people (used to fetch image data)
% names = ["alex", "angelo" , "cpi" , "david" , "felix" , "harun"];
% names = ["Anne_Hathaway", "barack_obama" , "Ben_Affleck" , "Brie_Larson" , "Emilia_Clarke", "Henry_Cavil","Hugh_Jackman"];
data_set = "face_data";

folders_raw = {dir(data_set).name};
len = length(folders_raw);
names = {folders_raw{3:len}};
% number of images to be used for training
trian_images_no = 5;
rows_ = 100;
cols_ = 100;
hor_partition_no = 3;

test_sample_size = 5;
offset = 1;

% place holder cell array
U = {};

% for each person in the name list
for name = names
    % matrix Xi (empty at the start)
    Ui = Get_Partioned_Class_Ui(data_set,name,trian_images_no,hor_partition_no,[rows_,cols_]);
    % add class of person to the class cell array U
    U{end+1} = Ui;
end



%%  prediction
classes = length(names);
close all;
clc;
% take a test image and convert it into vector



accuracy = [];

for name = names
    temp_acc = 0;
    img_path = data_set + "\" + name + "\";
    folders_raw = {dir(img_path).name};
    len = length(folders_raw);
    imgs = {folders_raw{3:len}};
    
    for test_no = trian_images_no + offset : trian_images_no + test_sample_size+offset
        
        test_U = Get_Partioned_Class_Ui(data_set,name,0,hor_partition_no,[rows_,cols_],test_no);
        subimg_no = 2*hor_partition_no;
        % if the image is a test
        file_name = img_path+ "\" + string(imgs{test_no});

        % if the image is in sample but not included in training
        file_name = data_set + "\" + name + "\" + imgs{test_no};

%         test_image = imread(file_name);
%         test_image2d = im2gray(test_image)';
%         test_image2d = imresize(test_image2d,[rows_,cols_]);
% 
%         figure(1);
%         imshow(test_image2d');
%         title("Test Case Image ");

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

                beta = (Xi'*Xi) \ Xi' * y;

                % estimate y_hat
                y_hat{i}{j} = Xi*beta;
                % compute and add the distance to d vector
                d{i} = [d{i} norm(y-y_hat{i}{j})];
            end


% 
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
        d_intermediate = {};
        for j = 1 : subimg_no
            d_temp = 0;
            for i = 1 : classes
                if i == 1 
                    d_temp = d{i}(j);
                    d_intermediate{j} = {i , d{i}(j)};
                else
                    if d_temp > d{i}(j)          
                        d_intermediate{j} = {i , d{i}(j)};
                        d_temp = d{i}(j);
                    end
                end
            end
        end

        class_pred = d_intermediate{1}{1};
        d_temp = d_intermediate{1}{2};

        for k = 1: subimg_no
            if d_temp > d_intermediate{k}{2}
                class_pred = d_intermediate{k}{1};
                d_temp = d_intermediate{k}{2};
            end
        end

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
