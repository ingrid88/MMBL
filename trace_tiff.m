function[] = trace_tiff()

%% parameters set here



close all;
%% choose the tiff stack
[filename, pathname, filterindex] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');

%% choose the trace to draw on tiff
[filename2, pathname2, filterindex2] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');
    
file = tdfread(filename2,'\t');
file = struct2cell(file);
x = file{3,1};
y = file{4,1};

x_new = x - x(1,1);
y_new = y - y(1,1);
%% choose the trace to draw on tiff 
[filename3, pathname3, filterindex3] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');
file3 = tdfread(filename3,'\t');
file3 = struct2cell(file3);
bx = file3{3,1};
by = file3{4,1};

by_new = by - y_new;
bx_new = bx - x_new;
B=VideoReader(filename);

%% best fit line (10 points ahead)
 Slope = [];
 YInt = [];
 count = 20;
 
 
for i = 1:length(x)-count
    
    SumX = sum(x(i:i+count));
    SumY = sum(y(i:i+count));
    SumX2 = sum(x(i:i+count).^2);
    SumXY = sum(x(i:i+count).*y(i:i+count));
    XMean = SumX / count;
    YMean = SumY / count;
    Slope(i,1) = (SumXY - SumX * YMean) / (SumX2 - SumX * XMean);
    YInt(i,1) = YMean - Slope(i,1) * XMean;
    
end

%% length of tiff stack
g = 1950;
outputFileName = 'test2.tif';
for i = 1:g
    C=read(B,i);
    A=C(:,:,1);
    imshow(A)
    perpX = [x(i);bx(i)];
    perpY = [y(i);by(i)];
    
    averageX = mean(x(i:i+10));
    vecX = [averageX-50:averageX+50];
    vecY = vecX.*Slope(i,1)+YInt(i,1);
    hold on;
    figure(1)
    plot(x(1:i),y(1:i),bx(1:i),by(1:i),perpX,perpY,vecX,vecY);
    hold on;
    
    %% Calculate angle
  %between two vectors: your new position, and the line made betweent the old Front position and Back position
   % y_new = x(1:end-count).*Slope+YInt;
    x_set = 10*ones(length(x)-count,1);
    y_set = x_set.*Slope+YInt;
    vectorX = x_set-x(1:end-count);
    vectorY = y_set-y(1:end-count);
    perpX = (bx(1:end-1)-x(1:end-1));
    perpY = (by(1:end-1)-y(1:end-1));
    angle = (acos((vectorX.*perpX(1:end-count+1)+vectorY.*perpY(1:end-count+1))./(sqrt(vectorX.^2+vectorY.^2).*sqrt(perpX(1:end-count+1).^2+perpY(1:end-count+1).^2))))*(180/pi);

    %different attempt
    slope1 = Slope;
    slope2 = (y_new-by_new)./(x_new-bx_new);
    slope2 = slope2(1:end-count);
    angle2 = 180/pi*atan(abs((slope1-slope2)./(1+slope1.*slope2)));

    %write the actual angle
    arcw = strcat(num2str(angle(i)),' degrees');
    
    %% angle written
     h = text(100,100,arcw,'color','w');
   
    f = getframe(gca);
    im = frame2im(f);
    hold off;
    % now you use "getframe" and "frame2im"
%  imwrite(im, outputFileName, 'WriteMode', 'append',  'Compression','none');
%     f = getframe(gca);
%     im = frame2im(f);
% 
%     imwrite(A,'image2.tif');

end