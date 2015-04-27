function[y]= Multitracker_Analysis()

[filename, pathname, filterindex] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');

fullname = strcat(pathname, filename);
% load the file
structure = tdfread(fullname);
% count number of columns

% prompt for columns interested in (eg: tracks [81,61, 32])
prompt = 'Which tracks should i follow (format [x,y,z,...])?';
result = input(prompt);

% for loop running through each set of X, Y coordinates (eg X21 Y21, X44
% Y44)
%test case
%result = [1,4,6];
tx = 1/20; % time between frames in sec
for i = 1:length(result)
    x_name    = strcat('X',num2str(result(i)));
    y_name    = strcat('Y',num2str(result(i)));
    x = structure.(x_name);
    y = structure.(y_name);
    
    % MSD
cutoff = 20*30; %sec
R = []; tR = [];
for i = 1 : cutoff, % NUMBERING FOR R
    sumR2 = 0;
    NR2   = 0;
    for j = 1 : length(x)-i, % WHERE TO BEGINs
        sumR2   = sumR2 + (x(i+j) - x(j))^2 + (y(i+j) - y(j))^2;
        NR2     = NR2 + 1;
    end;
    t(i) = i;
    R(i) = sumR2 / NR2;
end;
R       = R(1:cutoff);
tR      = t(1:cutoff)*tx;

figure(2)
loglog(tR,R);  hold on;
xlabel(gca,'time lag \tau (sec)','FontSize',14);
ylabel(gca,'MSD (um^2)','FontSize',14);

end

% Run MSD analyzer
% Save MSD (log / not log) Velocity graphs


end
