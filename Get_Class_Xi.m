function [Xi] = Get_Class_Xi(data_set,name,sample_img_no,img_resize,test_no)
% Get_Class_Xi gives matrix Xi for each class(person)
%   Xi = Get_Class_Xi(name,sample_img_no) gives Xi of size 100*100 X
%   sample_img_no
%
%   Xi = Get_Class_Xi(name,sample_img_resize) gives Xi of size rows_*cols_ X
%   sample_img_no , where sample_img_resize = [rows_, cols_]
%

img_path = data_set + "\" + name + "\";
folders_raw = {dir(img_path).name};
len = length(folders_raw);
imgs = {folders_raw{3:len}};

switch nargin
    case 3
        rows_ = 100;
        cols_ = 100;
        
        Xi = [];
        for j = 1:sample_img_no
            file_name = img_path+ "\" + string(imgs{j});
             % fetch image from the file name
            image = imread(file_name);
            image = imresize(image,[rows_,cols_]);
            % convert into gray (actual image has 3 matrices for one image)
            image2d = im2gray(image)';%( this will give us 2d matrix)
            image_col = image2d(:);
            image_col = image_col./norm(image_col);
            Xi = [Xi image_col];            
        end

    case 4
        rows_ = img_resize(1);
        cols_ = img_resize(2);
        
        Xi = [];
        for j = 1:sample_img_no
            file_name = img_path+ "\" + string(imgs{j});
             % fetch image from the file name
            image = imread(file_name);
            image = imresize(image,[rows_,cols_]);
            % convert into gray (actual image has 3 matrices for one image)
            image2d = im2gray(image)';%( this will give us 2d matrix)
            image_col = double(image2d(:));
            image_col = image_col./norm(image_col);
            Xi = [Xi image_col];            
        end
     case 5
        rows_ = img_resize(1);
        cols_ = img_resize(2);
        
        Xi = [];
        
            file_name = img_path+ "\" + string(imgs{test_no});
             % fetch image from the file name
            image = imread(file_name);
            image = imresize(image,[rows_,cols_]);
            % convert into gray (actual image has 3 matrices for one image)
            image2d = im2gray(image)';%( this will give us 2d matrix)
            image_col = double(image2d(:));
            image_col = image_col./norm(image_col);
            Xi = [Xi image_col];            
        
    
    otherwise
        error("not enough input arguments or too much input")
    
end