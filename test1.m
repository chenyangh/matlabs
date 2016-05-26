global fileID
fileID = fopen('myfile.txt','w');

for i = 1 : 397
    aCata = SUN(i);
    annotations = aCata.annotations;
    for j = 1 : length(annotations)
         toSave{i}{j} = getStruct(annotations{j});
         disp( [ i j ])
    end
    
end

fclose(fileID);

