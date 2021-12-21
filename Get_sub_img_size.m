function sub_img_size = Get_sub_img_size(hor_part,rows_,cols_)
    
    hor_part_size = floor(rows_/hor_part);
    

    sub_img_no = hor_part * 2;

    sub_img_size{1} =  [cols_/2 hor_part_size];
    for k = 1:sub_img_no -3
        sub_img_size{end+1} =  [cols_/2 hor_part_size];

    end

    i = hor_part - 1; 
    sub_img_size{end+1} = [cols_/2  rows_-i*hor_part_size];
    sub_img_size{end+1} = [cols_/2  rows_-i*hor_part_size];

end