function [reval, cata] = getPicByID( imgID, isTrain  )
    if nargin < 2
        isTrain = false;
    end
    
    global sorted_listing
    
    bachNum =  fix(imgID/100 );
    idxInBatch = rem(imgID , 100);
    
    if isTrain
        dir_str = '/Users/chenyanghuang/Desktop/projFiles/batch/train/';
    else
        dir_str = '/Users/chenyanghuang/Desktop/projFiles/batch/test/';
    end
    
    curren_name = strcat( dir_str , sorted_listing(bachNum).name);
    fid=fopen(curren_name);
    col9 = fread(fid);
    B = reshape(col9,30002,[]);
    B = B';
    img = B(idxInBatch, :);
    cata = img(1) + img(2);
    img = img(3:end);
    
    r = img(1:10000);
    g = img(10001:20000);
    b = img(20001:30000);
    r = reshape(r,[100,100])';
    g = reshape(g,[100,100])';
    b = reshape(b,[100,100])';
    reval = zeros([100,100,3]);
    reval(:,:,1) = r;
    reval(:,:,2) = g;
    reval(:,:,3) = b;
    reval=uint8(reval);
end