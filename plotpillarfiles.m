function[y]= plotpillarfiles(background_file,frame_rate,pixels_per_micrometer)
%grab file
close all;
[filename, pathname, filterindex] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');
c=1;
for i = 1:length(filename)
    if i == 1
       [x,y]= plotpillars(filename{1,i},background_file,c,frame_rate,pixels_per_micrometer);
    else
        plotpillars(filename{1,i},background_file,c,frame_rate,pixels_per_micrometer);
    end
    c=c+1;
end

GraphPillars(x,y);
%make array of names of files
% for length file_array
% plotpillars(file1,background_file)



end