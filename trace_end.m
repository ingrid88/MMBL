function[] = trace_end(outputFileName)


close all;
%choose the avi file
[filename, pathname, filterindex] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');

%choose the trace to draw on avi file
[filename2, pathname2, filterindex2] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');
    
file = tdfread(filename2,'\t');
file = struct2cell(file);
x = file{3,1};
y = file{4,1};

B=VideoReader(filename);
%length of tiff stack
g = 301;
outputFileName = 'pilJSS_trace.tif';

    C=read(B,1);
    A=C(:,:,1);
    imshow(A)
    hold on;
    plot(x,y);
    f = getframe(gca);
    im = frame2im(f);
    % now you use "getframe" and "frame2im"
    imwrite(im, outputFileName, 'WriteMode', 'append',  'Compression','none');


end