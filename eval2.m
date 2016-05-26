
global sorted_listing
%%

dir_str = '/Users/chenyanghuang/Desktop/projFiles/batch/test/';
listing = dir( strcat (dir_str, '*.bin') );
%% sort listing 
sorted_listing = [];
for i = 1 : 104
    to_find = strcat('test_', int2str(i), '.bin' );
    x = structfind( listing, 'name', to_find ) ;
    sorted_listing = [ sorted_listing, listing(x)];
end
listing = sorted_listing;



%% 1 : length(sorted_listing)
label = [];
for i = 1 : length(sorted_listing)
    sorted_listing(i).name
    curren_name = strcat( dir_str , sorted_listing(i).name);
    fid=fopen(curren_name);
    col9 = fread(fid);
    
    B = reshape(col9,30002,[]);
    B = B';
    label = [ label ;B(:,1) + B(:,2) ];
    fclose(fid);
end

%% test





