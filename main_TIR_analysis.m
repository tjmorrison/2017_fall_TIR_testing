%%Matlab code to examine data from fall 2017 FLIR data collection 

clear; clc; close all; 
%add library 
addpath('C:\Users\Derek\Documents\GitHub\functions_library\')
%plot defults 
ft_size = 25;
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultTextInterpreter','latex'); 
set(0,'DefaultAxesFontSize',ft_size); 
%% Load data
%load october 19th
%load 5 min of turn data from expensive camera
load('C:\Users\Derek\Documents\GitHub\2017_fall_TIR_testing\Processed_data\19Oct2017\expensive_5min.mat')
TIR_turf.T = frame(1:2:end,1:2:end,1:end-1);
clear frame;
%% load October 18th
path = 'H:\Data\TIR_test_fall_17\FLIR DATA 18 oct 2018\expensive_000009-291_08_24_47_675.ats';
[ frame ] = Load_FLIR_data( path,1,1,1,1,1,1,1,1,1);

TIR_field.T = frame(20:2:end,1:2:end,1:end-1);
clear frame;

%% load October 17th
path = 'H:\Data\TIR_test_fall_17\FLIR DATA 17oct 2017\expensive_000005-290_10_23_37_122.ats';
[ frame ] = Load_FLIR_data( path,1,1,1,1,1,1,1,1,1);

TIR_field.T = frame(20:2:end,1:2:end,1:end-1);
clear frame;

%% Decompose signal
avg_window = 10*60*5; %5min chunk
%turf
[TIR_turf.T_fluct, TIR_turf.T_patch, TIR_turf.T_trend, TIR_turf.T_mean]=compute_TIR_components(TIR_turf.T,avg_window);
%% field
avg_window = 10*60*5; %5min chunk
[TIR_field.T_fluct, TIR_field.T_patch, TIR_field.T_trend, TIR_field.T_mean]=compute_TIR_components(TIR_field.T,avg_window);

%% Compute Spectra



%% Plots
figure(1)
subplot(2,2,1)
pcolor(flip(TIR_field.T(:,:,1)))
shading interp
colorbar 
ylabel('$\overline{T}^{5min}$')
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
%caxis([290 310])
h = colorbar;
set(get(h,'title'),'string','K','interpreter','latex');
tmp=get(gca,'position');
set(gca,'position',[1*tmp(1) .9*tmp(2) 1.1*tmp(3) 1.05*tmp(4)])

subplot(2,2,2)
pcolor(flip(TIR_field.T_fluct(:,:,3000)));
shading interp
colorbar 
%caxis([-.5 0.3])
ylabel('T$_{fluct}^{instant}$')
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
h = colorbar;
set(get(h,'title'),'string','K','interpreter','latex');
tmp=get(gca,'position');
set(gca,'position',[1*tmp(1) .9*tmp(2) 1.1*tmp(3) 1.05*tmp(4)])

subplot(2,2,3)
pcolor(flip(TIR_field.T_patch))
shading interp
colorbar 
%caxis([0 10])
ylabel('T$_{patch}^{5min}$')
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
h = colorbar;
set(get(h,'title'),'string','K','interpreter','latex');
tmp=get(gca,'position');
set(gca,'position',[1*tmp(1) .9*tmp(2) 1.1*tmp(3) 1.05*tmp(4)])

subplot(2,2,4)
plot(linspace(0,5,3000),TIR_field.T_trend,'k-')
xlabel('time (min)')
ylabel('T$_{trend}$ (K)')
tmp=get(gca,'position');
set(gca,'position',[1.03*tmp(1) 1*tmp(2) .9*tmp(3) 1*tmp(4)])
axis tight
grid on 

[ax]=subtitle('SC6700 October 17th: 10am MST Playa Site');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(figure(1),[pwd '\figures\17Oct2017\SC6700_5min_overview.fig']);
saveas(figure(1),[pwd '\figures\17Oct2017\SC6700_5min_overview.png']);

%%
figure(3)
subplot(2,2,1)
pcolor(flip(TIR_turf.T(:,:,1)))
shading interp
colorbar 
ylabel('$\overline{T}^{5min}$')
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
caxis([290 310])
h = colorbar;
set(get(h,'title'),'string','K','interpreter','latex');
tmp=get(gca,'position');
set(gca,'position',[1*tmp(1) .9*tmp(2) 1.1*tmp(3) 1.05*tmp(4)])

subplot(2,2,2)
pcolor(flip(TIR_turf.T_fluct(:,:,1)));
shading interp
colorbar 
caxis([-1 1])
ylabel('T$_{fluct}^{instant}$')
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
h = colorbar;
set(get(h,'title'),'string','K','interpreter','latex');
tmp=get(gca,'position');
set(gca,'position',[1*tmp(1) .9*tmp(2) 1.1*tmp(3) 1.05*tmp(4)])

subplot(2,2,3)
pcolor(flip(TIR_turf.T_patch))
shading interp
colorbar 
caxis([0 10])
ylabel('T$_{patch}^{5min}$')
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
h = colorbar;
set(get(h,'title'),'string','K','interpreter','latex');
tmp=get(gca,'position');
set(gca,'position',[1*tmp(1) .9*tmp(2) 1.1*tmp(3) 1.05*tmp(4)])

subplot(2,2,4)
plot(linspace(0,5,3000),TIR_turf.T_trend,'k-')
xlabel('time (min)')
ylabel('T$_{trend}$ (K)')
tmp=get(gca,'position');
set(gca,'position',[1.03*tmp(1) 1*tmp(2) .9*tmp(3) 1*tmp(4)])
axis tight
grid on

[ax]=subtitle('SC6700 October 19th: U of U Turf');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(figure(3),[pwd '\figures\19Oct2017\SC6700_5min_overview.fig']);
saveas(figure(3),[pwd '\figures\19Oct2017\SC6700_5min_overview.png']);
%% Movie of 
figure()
for i = 1:1000
    pcolor(flip(TIR_field.T_fluct(:,:,i)));
    shading interp
    colorbar 
    colormap default 
    caxis([-.12 .12])
    pause(.01)
end



