
%cd 'C:\Users\Nicolas\Desktop\New folder (3)\10202014'
%bonc = load('nerd12_5.txt');
%close all
function[y]= MSD(array)
bonc = load(array);
%%bonc2 = load('0fl561.txt');

px = 1/11.66; % um/pixel : 0.0645 - 100X back; 0.2674 - 20X mid
             % 0.155 - 60X front;             
x = px * (bonc(:,2)-bonc(1,2));
y = px * (bonc(:,3)-bonc(1,3));
fr = length(x);
tx = 1/20; % time between frames in sec

%%xf = px * (bonc2(:,2)-bonc2(1,2));
%%yf = px * (bonc2(:,3)-bonc2(1,3));

% yap = figure(1); plot(x,y,'.-k','LineWidth',1.5); %,'MarkerSize',1);
% hold on
% %plot(xf,yf,'-r');
% plot(x(1),y(1),'sw','MarkerSize',17,'MarkerFaceColor','w');
% plot(x(fr),y(fr),'^w','MarkerSize',17,'MarkerFaceColor','w');
% c = [0.7 0.7 0.7];
% scatter(x(1),y(1),'sk','SizeData',150,'MarkerFaceColor',c,'MarkerEdgeColor',[0 0 0],'LineWidth',2);
% scatter(x(fr),y(fr),'^k','SizeData',150,'MarkerFaceColor',c,'MarkerEdgeColor',[0 0 0],'LineWidth',2);
% axis square, grid on
% % lowx = 5*floor(min(x)/5); lowy = 5*floor(min(y)/5);
% % highx = 5*ceil(max(x)/5); highy = 5*ceil(max(y)/5);
% % dim = max(highx-lowx, highy-lowy);
% % set(gca,'XLim',[lowx-5 highx], 'YLim', [lowy highy],...
% %     'FontSize',12,'GridLineStyle',':','XTick',[lowx-5:5:highx],'YTick',[lowy:5:highy]);
% lowx = floor(min(x)); lowy = floor(min(y));
% highx = ceil(max(x)); highy = ceil(max(y));
% dimx = highx-lowx; dimy = highy-lowy; dim = max(dimx,dimy);
% set(gca,'XLim',[lowx-floor(abs((dimx-dim)/2)) highx+abs(dimx-dim)-floor(abs((dimx-dim)/2))],...
%     'YLim', [lowy-floor(abs((dimy-dim)/2)) highy+abs(dimy-dim)-floor(abs((dimy-dim)/2))],...
%     'FontSize',12,'GridLineStyle',':',...
%     'XTick',[0:2:6],'YTick',[-2:2:4]);
% xlabel(gca,'distance (um)','FontSize',14);
% ylabel(gca,'distance (um)','FontSize',14);
% % scatter(lowx-5+1.5,highy-1.5,'sk','SizeData',120,'MarkerFaceColor',c,'MarkerEdgeColor',[0 0 0],'LineWidth',2);
% % scatter(lowx-5+1.5,highy-4,'^k','SizeData',120,'MarkerFaceColor',c,'MarkerEdgeColor',[0 0 0],'LineWidth',2);
% % text(lowx-5+2.5, highy-1.5, 'start','FontSize',10);
% % text(lowx-5+2.5, highy-4, 'end','FontSize',10);
% scatter(lowx+0.5,5-0.5,'sk','SizeData',120,'MarkerFaceColor',c,'MarkerEdgeColor',[0 0 0],'LineWidth',2);
% scatter(lowx+0.5,5-1,'^k','SizeData',120,'MarkerFaceColor',c,'MarkerEdgeColor',[0 0 0],'LineWidth',2);
% text(lowx+0.8, 5-0.5, 'start','FontSize',10);
% text(lowx+0.8, 5-1, 'end','FontSize',10);
% 
 string      = {array};
 newstring   = string{1}(1:end-4);
% 
% name     = strcat('location_',newstring);
% saveas(yap,name,'fig')
% saveas(yap,name,'jpg')
% local speed
% v = abs(sqrt((x(2:fr)-x(1:fr-1)).^2+(y(2:fr)-y(1:fr-1)).^2))/tx; %um/sec
% vm = mean(v); vstd = std(v);
% figure(2); hist(v,10);
% axis square, box on
% heigh = 150;
% set(gca,'YLim',[0 heigh],'YTick',[0: heigh/3 : heigh],...
%     'FontSize',12);
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor',[0.4 0.4 0.4],'EdgeColor','k','LineWidth',1.5);
% xlabel(gca,'speed over 1 sec (um/sec)','FontSize',14);
% ylabel(gca,'counts','FontSize',14);

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

%p = polyfit(log10(tR(1:10)),log10(R(1:10)),1)



rip = figure(10);
loglog(tR,R);  hold on;
grid on
Xticks = [1 10 100];
Yticks = [0.1 1 10];
set(gca,'XLim',[1 500], 'YLim', [0.05 60],...
    'FontSize',12,'XTick',Xticks,'XTickLabel',Xticks,'YTick',Yticks,'YTickLabel',Yticks);
grid minor
xlabel(gca,'time lag \tau (sec)','FontSize',14);
ylabel(gca,'MSD (um^2)','FontSize',14);

name     = strcat('MSD_log_',newstring);
saveas(rip,name,'fig');
saveas(rip,name,'jpg');

%draw a line of exp 1 on log log
% rip = figure(3); hold on
% loglog(tR,R,'-s'); 
% % loglog(tR,R,'.-k','LineWidth',1); 
% % axis square, grid on, box on
% % set(gca,'GridLineStyle',':','FontSize',12);
% % high = ceil(max(ceil(log10(max(tR))), ceil(log10(max(R))))/10);
% % % Xticks = [1 10 100];
% % % Yticks = [0.1 1 10];
% % % set(gca,'XLim',[1 500], 'YLim', [0.05 60],...
% % %     'FontSize',12,'XTick',Xticks,'XTickLabel',Xticks,'YTick',Yticks,'YTickLabel',Yticks);
% % grid minor
% xlabel(gca,'time lag \tau (sec)','FontSize',14);
% ylabel(gca,'MSD (um^2)','FontSize',14);



%draw a line of exp 1 on log log
h = figure(1); hold on
plot(tR,R,'.-k','LineWidth',1); 
axis square, grid on, box on
set(gca,'GridLineStyle',':','FontSize',12);
high = ceil(max(ceil(10*log10(max(tR))), ceil(10*log10(max(R))))/10);
% Xticks = [1 10 100];
% Yticks = [0.1 1 10];
% set(gca,'XLim',[1 500], 'YLim', [0.05 60],...
%     'FontSize',12,'XTick',Xticks,'XTickLabel',Xticks,'YTick',Yticks,'YTickLabel',Yticks);
grid minor
xlabel(gca,'time lag \tau (sec)','FontSize',14);
ylabel(gca,'MSD (um^2)','FontSize',14);


name     = strcat('MSD_',newstring);
saveas(h,name,'fig');
saveas(h,name,'jpg');


mur = R./tR;
%draw a line of exp 1 on log log
yip = figure(2); hold on;
plot(tR,mur,'.-k','LineWidth',1); 
axis square, grid on, box on
set(gca,'GridLineStyle',':','FontSize',12);
high = ceil(max(ceil(10*log10(max(tR))), ceil(10*log10(max(R))))/10);
% Xticks = [1 10 100];
% Yticks = [0.1 1 10];
% set(gca,'XLim',[1 500], 'YLim', [0.05 60],...
%     'FontSize',12,'XTick',Xticks,'XTickLabel',Xticks,'YTick',Yticks,'YTickLabel',Yticks);
grid minor
xlabel(gca,'time lag \tau (sec)','FontSize',14);
ylabel(gca,'Speed (um/s)','FontSize',14);

% name     = strcat(newstring,'_speed');
% saveas(h,name,'fig');
% saveas(h,name,'jpg');
% x2 = tR(2:8); y2 = 10.^(2*log10(x2));
% plot(2*x2,y2,'Color',[0.4 0.4 0.4],'LineWidth',2.5);

%x1 = tR(2:30); y1 = 10.^(1*log10(x1));
%plot(2*x1,R(x1(1))*y1/3,'Color',[0.4 0.4 0.4],'LineWidth',2.5); 
     
name     = strcat('velocity_',newstring);
saveas(yip,name,'fig');
saveas(yip,name,'jpg');


end
