function [Ui] = Get_Partioned_Class_Ui(data_set,name,sample_img_no,hor_part,img_resize,test_no)
% Get_Partioned_Class_Ui gives dictionary of matrices wi's for each class(person)
%   
% Get_Partioned_Class_Ui(name,sample_img_no,hor_part) gives dictionary of size number of subimages
% wi's size will depend on the number of subimages, the image will be resized to 100 X 100
%
% Get_Partioned_Class_Ui(name,sample_img_no,hor_part,img_resize) gives dictionary of size number of subimages
% wi's size will depend on the number of subimages.
%  where img_resize = [rows_, cols_] , the images will be resized to this size
%
%Get_Partioned_Class_Ui(name,sample_img_no,hor_part,img_resize,exact_image_no)
%this wil give the Ui for the exact image number specified , keep 0 for sample_img_no
img_path = data_set + "\" + name + "\";
folders_raw = {dir(img_path).name};
len = length(folders_raw);
imgs = {folders_raw{3:len}};

switch nargin
    case 4
        rows_ = 100;
        cols_ = 100;
 
        size_arr = [];
        
        hor_part_size = floor(rows_/hor_part);
        sub_img_no = hor_part * 2;
        
        slpliting_row = [];
        for i = 1 : hor_part-1
            slpliting_row = [slpliting_row hor_part_size];
        end
        slpliting_row = [slpliting_row  rows_-i*hor_part_size];

        for j = 1:sample_img_no
            file_name = img_path+ "\" + string(imgs{j});
             % fetch image from the file name
            image = imread(file_name);
            image = imresize(image,[rows_,cols_]);
            % convert into gray (actual image has 3 matrices for one image)
            image2d = im2gray(image)';%( this will give us 2d matrix)
            sub_img_dict = mat2cell(image2d,[cols_/2 cols_/2], [slpliting_row]);

            if j == 1 
                Ui = {};
                for k = 1:sub_img_no
                    Ui{k} = sub_img_dict{k}(:);
                end
            else
                for k = 1:sub_img_no
                    Ui{k} = [Ui{k} sub_img_dict{k}(:)];
                end
            end
        end

    case 5
        rows_ = img_resize(1);
        cols_ = img_resize(2);
        
        size_arr = [];
        
        hor_part_size = floor(rows_/hor_part);
        sub_img_no = hor_part * 2;
        
        slpliting_row = [];
        for i = 1 : hor_part-1
            slpliting_row = [slpliting_row hor_part_size];
        end
        slpliting_row = [slpliting_row  rows_-i*hor_part_size];

        for j = 1:sample_img_no
            file_name = img_path+ "\" + string(imgs{j});
             % fetch image from the file name
            image = imread(file_name);
            image = imresize(image,[rows_,cols_]);
            % convert into gray (actual image has 3 matrices for one image)
            image2d = im2gray(image)';%( this will give us 2d matrix)
            sub_img_dict = mat2cell(image2d,[cols_/2 cols_/2], [slpliting_row]);

            if j == 1 
                Ui = {};
                for k = 1:sub_img_no
                    Ui{k} = sub_img_dict{k}(:);
                end
            else
                for k = 1:sub_img_no
                    Ui{k} = [Ui{k} sub_img_dict{k}(:)];
                end
            end
        end

    case 6
        rows_ = img_resize(1);
        cols_ = img_resize(2);
        
        size_arr = [];
        
        hor_part_size = floor(rows_/hor_part);
        sub_img_no = hor_part * 2;
        
        slpliting_row = [];
        for i = 1 : hor_part-1
            slpliting_row = [slpliting_row hor_part_size];
        end
        slpliting_row = [slpliting_row  rows_-i*hor_part_size];

        
        file_name = img_path + "\" + imgs{test_no};
         % fetch image from the file name
        image = imread(file_name);
        image = imresize(image,[rows_,cols_]);
        % convert into gray (actual image has 3 matrices for one image)
        image2d = im2gray(image)';%( this will give us 2d matrix)
        sub_img_dict = mat2cell(image2d,[cols_/2 cols_/2], [slpliting_row]);
        Ui = {};
        for k = 1:sub_img_no
            Ui{k} = sub_img_dict{k}(:);
        end

        
    otherwise
        error("not enough input arguments or too much input")
end