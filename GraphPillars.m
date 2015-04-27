function[k]= GraphPillars(x,y)

sprintf(x)
sprintf(y)
k=1;
fid = fopen(x,'rt');

datacell = textscan(fid, '%f32%f32%f32%f32%f32%f32', 'HeaderLines',1);
datanum = tdfread(y);


%datacell{1,1} Count
count = datacell{1,1};
%datacell{1,2} Max_location
max_location = datacell{1,2};
%datacell{1,3} Distance(uM)
distance = datacell{1,3};
%datacell{1,5} speed(um/s)
speed = datacell{1,5};
%datacell{1,6} duration(s)
duration = datacell{1,6};

%fclose(fid); 

j=1;
end
