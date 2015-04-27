function[M]= MSD(H)
close all;
[filename, pathname, filterindex] = uigetfile( ...
{  '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');
    M = [];
for j = 1:length(filename)

        sample = char(filename(1,j));
        hep = 2;
        bonc = load(sample);

        px = 1/19.16; % 60x on Flash: 11.5px/um, 100x on Flash: 19.16px / um         
        x = px * (bonc(:,2)-bonc(1,2));
        y = px * (bonc(:,3)-bonc(1,3));
        fr = length(x);
    %% instantaneous speed
        instantaneous = sqrt((x(1:end-1) - x(2:end)).^2+ (y(1:end-1) - y(2:end)).^2);
        M(j,1) = mean(instantaneous)*10;
        M(j,2) = fr;

    %% average instantaneous 
        R = 5; %averaging 5 frames
        
        
        instantaneous = sqrt((x(1:end-1) - x(2:end)).^2+ (y(1:end-1) - y(2:end)).^2);
        average_instantaneous = [];
        for i = 1:length(instantaneous)-6
            x_avg(i,1) = sum(x(i:i+R-1))/R;
            y_avg(i,1) = sum(y(i:i+R-1))/R;
            average_instantaneous(i,1) = sum(instantaneous(i:i+R-1))/R;
        end
        M2(j,1) = mean(instantaneous)*10;
        M2(j,2) = fr;


    %% speed looking every H frames
        %H = 10; %speed of every 10 frames
        instantaneous2 = sqrt((x(1:end-H) - x(H+1:end)).^2+ (y(1:end-H) - y(H+1:end)).^2);
        M3(j,1) = mean(instantaneous2)*(10/H);
        M3(j,2) = fr;

        %% average R frames speed every H frames
        averaged_multiframes =  sqrt((x_avg(1:end-H) - x_avg(H+1:end)).^2+ (y_avg(1:end-H) - y_avg(H+1:end)).^2);
        speeds = averaged_multiframes*(10/H);
        M4(j,1) = mean(averaged_multiframes)*(10/H);
        M4(j,2) = fr;
     %% Calculate the VAF  @ dt H
    VAF = [];
    
    %smoothed over 5 frames
%     velocity_x = (x_avg(1:end-H) - x_avg(H+1:end))*(10/H);
%     velocity_y = (y_avg(1:end-H) - y_avg(H+1:end))*(10/H);
    
    %instantaneous
    velocity_x = abs((x(1:end-H) - x(H+1:end))*(10/H));
    velocity_y = abs((y(1:end-H) - y(H+1:end))*(10/H));
    
    % VAFc is the velocity components calculated and then mean of dot product of
    % components added. So over all velocities from 1 to length of array divided by ... 
    for k = 1 : length(bonc)/10 
       VAF(k,1) =  mean(speeds(1+k:end).*speeds(1:end-k));
       VAFc(k,1) = mean(velocity_x(1+k:end).*velocity_x(1:end-k)+velocity_y(1+k:end).*velocity_y(1:end-k));
    end;   

    %% Calculate the MSD 
    MSDcalc = [];
    for k = 1 : length(bonc)/10
      MSDcalc(k,1) =  mean((x_avg(1+k:end) - x_avg(1:end-k)).^2+ (y_avg(1+k:end) - y_avg(1:end-k)).^2);
    end;   
    
figure(j*4-2)
t = (1:length(VAFc))'.*(1/10);
plot(t,VAFc);

figure(j*4-1)
t = (1:length(MSDcalc))'.*(1/10);
loglog(t,MSDcalc);
    
figure(j*4)

axis equal;
plot(x,y,x_avg,y_avg)

axis equal;
figure(j*4-3)
        
end
M_avg = sum(M(:,1).*M(:,2))/sum(M(:,2))
M3_avg = sum(M3(:,1).*M3(:,2))/sum(M3(:,2))
M4_avg = sum(M4(:,1).*M4(:,2))/sum(M4(:,2))
f = filename'




hi = 3;

 
end
