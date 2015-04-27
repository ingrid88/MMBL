

% Example: you would write the following in matlab: plotpillars ('FA1090betapiallarsOnehour_1_pillar8.txt','FA1090betapiallarsOnehour_1_pillarB.txt')
% Output files directly into your folder: jpg graph of plot and a txt file
% with max_location, max_store,force,speed output (comma delimited).
% with the distance data txt file if you wish to plot in another program

function[sumname,distname]= plotpillars(pillar_file, background_file,counter,frame_rate,pixels_per_micrometer)

%Load background file
background = tdfread(background_file,'\t');
background = struct2cell(background);
bx = background{3,1};
by = background{4,1};
b=[bx,by];
y = pillar_file;
%Load pillar file
pillar = tdfread(pillar_file,'\t');
pillar = struct2cell(pillar);
px = pillar{3,1};
py = pillar{4,1};
c = pillar{1,1};
p=[bx,by];

%calculate distance, force and speed of contraction 
len = length(p);
dist=zeros(len,1);
% F = -kx where x is distance and k is 25pN/um

pair = zeros(len,2);
pair(:,2) = c;
%pixel distances 
for i = 1:len
    pair(i,1) = sqrt(((px(i)-px(4))-(bx(i)-bx(4)))^2+((py(i)-py(4))-(by(i)-by(4)))^2);
end
per = 1;
zip = mean(pair(:,1));
[minval,ind]=min(abs(pair(:,1)-zip));



% calculate point at which the pillar is centered... 
% this is the point closest to average dist

%pixel distances 
for i = 1:len
    dist(i,1) = sqrt(((px(i)-px(ind-1))-(bx(i)-bx(ind-1)))^2+((py(i)-py(ind-1))-(by(i)-by(ind-1)))^2);
end

dist = dist - mean(dist);
% actual distance
dist = dist/pixels_per_micrometer;
%11.44
% force applied
force = dist*25;

% speed is slope of curve  - rise over run:  [y - y.] / [x - x.]
max_store = zeros(20,1);
max_location = zeros(20,1);
speed = zeros(20,1);
duration = zeros(20,1);

slope = (dist(2:end)-dist(1:end-1)); 


peak_ar = dist(slope>0);
peak_arl = c(slope>0);
%peak_arl = c(slope>0);
peak_ar_seg=zeros(length(peak_arl),1);
peak_ar_segl=zeros(length(peak_arl),1);
peak_terms = zeros(length(peak_arl),1);
m=1;
j=1;
        peak_seg_length = 1;
		down_seg_length = 0.1;
        down_seg_distance = 1;
        i=1;
while i <= length(slope)-2
    while (down_seg_length) <= (0.2*peak_seg_length) & i <= length(slope)-2 & down_seg_distance <= 4
        if sign(slope(i)) == 1
            peak_ar_seg(m,1)=dist(i);
            peak_ar_segl(m,1)=c(i);
            peak_terms = peak_ar_seg;
            peak_terms(m+1,1)=dist(i+1);
            m=m+1;
            i = i+1;
        elseif sign(slope(i)) == -1 && length(peak_ar_seg(peak_ar_seg~=0))>3
            peak_seg_length = max(peak_terms(peak_terms~=0))-min(peak_ar_seg(peak_ar_seg~=0));
            down_seg_length = abs(max(peak_terms(peak_terms~=0))-dist(i+1));
            down_seg_distance = find(dist==max(peak_terms))-c(i);
            pin = 2;
            peak_ar_seg(m,1)=dist(i);
            peak_ar_segl(m,1)=c(i);
            m=m+1;
            i=i+1;
        else
            i=i+1;
            break;
         end
    end
    peak_ar_seg=peak_ar_seg(peak_ar_seg~=0);
    peak_ar_segl=peak_ar_segl(peak_ar_segl~=0);
    if length(peak_ar_seg)>4 && max(peak_ar_seg)>0.12            
            valmin      = dist(dist==peak_ar_seg(1,1)); % min pull distance (taken to be first point above threshold)
            valmind     = find(dist==peak_ar_seg(1,1)); % index of min pull distance
            valmaxd     = find(dist==max(peak_ar_seg)); % index of max pull distance
            valmax      = dist(dist==max(peak_ar_seg)); % max pull distance
            speed(j,1) = ((valmax-valmin)/((valmaxd-valmind)/frame_rate));% speed (big distance - small distance)/(big time - small distance)% um/s units
            duration(j,1)= (valmaxd-valmind)/frame_rate;
            %find the max value within peak_array and store into max_store
            max_store(j,1)      = max(peak_ar_seg);
            max_location(j,1)   = find(dist==max(peak_ar_seg));
            j=j+1;
    end            
    peak_ar_seg=zeros(length(peak_arl),1);
    peak_ar_segl=zeros(length(peak_arl),1);
    peak_seg_length = 1;
    down_seg_length = 0.1;
    down_seg_distance = 1;
    m=1;
end


force = max_store*25;

%calculate speed of each pull
max_location= max_location(max_location~=0);
max_store   = max_store(max_location~=0);
force       = force(max_location~=0);
speed       = speed(speed~=0);
duration = duration(duration~=0);


% create array with all data compiled
counters = ones(length(max_location),1);
counters = counters*counter;
if ~isempty(max_location)
sum = [counters, max_location, max_store,force,speed, duration];

sum_label = 'Count Max_location Distance(uM) force(N) speed(um/s) duration(s)';

%make txt file with: 'max_location', 'max_store','force','speed','duration'
string      = {background_file};
newstring   = string{1}(1:end-4);
sumname     = strcat(newstring,'_sum.txt');
    if counter==1
        fid = fopen(sumname,'w');
        fprintf(fid,'%s',sum_label);
    end
dlmwrite(sumname, sum, '-append','delimiter','\t','roffset',1);
end


%Graph data
%figure(counter);
%c = c/21;
grph = plot(c,dist);

%create jpg name for file
stringz      = {pillar_file};
newstring   = stringz{1}(1:end-4);
jpgname     = strcat(newstring,'.jpg');

%save the jpg                         
%saveas(grph,jpgname);
%clf;

%make txt file with #pulls total, total time of video, frequency of pulls 
%compiled frequency data
frequency = length(speed)/(len/frame_rate);
pulls = length(speed);
total_time = len/frame_rate;
filenm=newstring(end-1:end);
pull_data = [pulls, total_time,frequency];
pull_label = 'file_name pulls total_time frequency';
%make txt file with distance data  
strings      = {background_file};
newstring   = strings{1}(1:end-4);
distname    = strcat(newstring,'_pullnum.txt');
% i=1;
% if i=1
% fid = fopen(distname,'w');
% fprintf(fid,'%s',pull_label);
% i=i+1;
% end
dlmwrite(distname, pull_data,'-append','delimiter','\t');



end