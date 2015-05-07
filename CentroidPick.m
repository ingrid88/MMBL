function[] = CentroidPick(file_name)

%%load the avi file
A = VideoReader(file_name);
avi_length = A.NumberOfFrames;
b = read(A,1);
imshow(b);

%% how many bacteria to pick
prompt = 'how many bacteria do you want to track?  ';
val = input(prompt);
[x,y] = ginput(val); 
close all;

% pre-allocated arrays and cells
list = [];
listF = [];
listR = [];
orientate = [];


CentroidKeep = cell(1,val);
OrientationKeep = cell(1,val);
BacteriaLength = cell(1,val);

%% find the bacteria
for i = 1:avi_length
    B=read(A,i);
    C=B(:,:,1);  

    %% Derivative of Image
    [FX, FY] = gradient(double(C), 1);
    deriv_1 = FX.*FX + FY.*FY;
    diff_threshold      =     40;
    binary_mask = deriv_1 > diff_threshold;


    %% Filtering 
            R = 2;          % radius of dilation / erosion. R specifies the radius. R must be a nonnegative integer
            N = 4;          %  N must be 0, 4, 6, or 8
            SE = strel('disk', R, N);
            min_size = 50;

    binary_mask = imdilate(binary_mask, SE);
    %   imshow(binary_mask)
    binary_mask = imerode(binary_mask, SE);
    %   imshow(binary_mask)
    binary_mask = imfill(binary_mask, 'holes'); 
    %   imshow(binary_mask)
    binary_mask = imerode(binary_mask, SE);
    %   imshow(binary_mask)
    binary_mask = bwareaopen(binary_mask, min_size);
       imshow(binary_mask)


%% COM and # of clusters
        hohenkamp_p = 4;
        [cluster_label, cluster_num] = bwlabel(binary_mask, hohenkamp_p);
         COM = zeros(cluster_num,2);   

    for i=1:cluster_num
         [pos_y,pos_x] = find(cluster_label == i);
         COM(i,1) = mean(pos_x);
         COM(i,2) = mean(pos_y);       
    end 

        actual_cluster_num = length(x); %chosen by user
        cluster_label2 = zeros(size(cluster_label));
        cluster_label3 = zeros(size(cluster_label));
        
%% Centroids, Orientation, size of bacteria
        count = 1;
    for i = 1:actual_cluster_num
        
        %set cluster matrix size
        cluster_label2 = zeros(size(cluster_label));
        
        %find COM's that are closest to use picked bacteria
        d = (x(i)-COM(:,1)).^2+(y(i)-COM(:,2)).^2;
        [a b] = min(d);
        track_list(i,1) = b;
        
        %redefine the x and y coordinate of the bacteria
        x(i) = COM(b,1);
        y(i) = COM(b,2);
        
        cluster_label2(cluster_label==b)=1; 
        
        cluster_label3(cluster_label==b)=b;  
        
        %Centroid, Major axis length and orientation of bacteria array
        s = regionprops(cluster_label2,'Centroid','MajorAxisLength','Orientation');
        
        %centroid
        CentroidKeep{i} = [CentroidKeep{i}; [s(1).Centroid]];
        %orientation
        OrientationKeep{i} = [OrientationKeep{i}; [s(1).Orientation]];
        %majoraxislenght
        BacteriaLength{i} = [BacteriaLength{i}; [s(1).MajorAxisLength]];
        
        count = count+1;
    end

imshow(cluster_label3);
h = 34;

end


%% create jpg name for file
name     = {file_name};
name   = name{1}(1:end-4);
name1    = strcat(name,'_results.txt');
dlmwrite(name1, CentroidKeep,'delimiter','\t');
% 
% fileID = fopen('celldata.dat','w');
% formatSpec = '%s %d %2.1f %s\n';
% name2    = strcat(name,'_resultsF.txt');
% name3    = strcat(name,'_resultsR.txt');
% name4    = strcat(name,'_results_Orientation.txt');
% dlmwrite(name1, list,'delimiter','\t');
% dlmwrite(name2, listR,'delimiter','\t');
% dlmwrite(name3, listF,'delimiter','\t');
% dlmwrite(name4, orientate,'delimiter','\t');


end