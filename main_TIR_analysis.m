%%Matlab code to examine data from fall 2017 FLIR data collection 

clear; clc; close all; 
%%
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

TIR_field.T = frame(20:end,1:end,1:1200);
clear frame;

%% Decompose signal
avg_window = 10*60*5; %5min chunk
%turf
[TIR_turf.T_fluct, TIR_turf.T_patch, TIR_turf.T_trend, TIR_turf.T_mean]=compute_TIR_components(TIR_turf.T,avg_window);
%% field
avg_window = 10*60*2; %5min chunk
[TIR_field.T_fluct, TIR_field.T_patch, TIR_field.T_trend, TIR_field.T_mean]=compute_TIR_components(TIR_field.T,avg_window);

%% Compute Spectra



%% Plots
%plot Feild data
figure()
subplot(2,2,1)
pcolor(flip(mean(TIR_field.T,3)))
shading interp
colorbar 
colormap jet
%caxis([290 310])

subplot(2,2,2)
pcolor(flip(TIR_field.T_fluct(:,:,100)));
shading interp
colorbar 
colormap jet
%caxis([-1 1])


subplot(2,2,3)
pcolor(flip(TIR_field.T_patch(:,:,1)))
shading interp
colorbar 
colormap jet
%caxis([0 10])

subplot(2,2,4)
plot(linspace(0,5,600),TIR_field.T_trend)

[ax]=subtitle(['Tower Height: ',num2str(heights(z)),' m, Model: Shao']);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, .7, 0.96]);
saveas(figure(1),[pwd '/field/',num2str(heights(z)),'m/Shao_model_output.fig']);
saveas(figure(1),[pwd '/plots_results/',num2str(heights(z)),'m/Shao_model_output.png']);
%
%%
%plot TURF data
figure()
subplot(2,2,1)
pcolor(flip(TIR_turf.T(:,:,1)))
shading interp
colorbar 
caxis([290 310])

subplot(2,2,2)
pcolor(flip(TIR_turf.T_fluct(:,:,1)));
shading interp
colorbar 
caxis([-1 1])


subplot(2,2,3)
pcolor(flip(TIR_turf.T_patch))
shading interp
colorbar 

caxis([0 10])

subplot(2,2,4)
plot(linspace(0,5,3000),TIR_turf.T_trend)

[ax]=subtitle(['October 19th: U of U Turf']);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, .7, 0.96]);
% saveas(figure(1),[pwd '/field/',num2str(heights(z)),'m/Shao_model_output.fig']);
% saveas(figure(1),[pwd '/plots_results/',num2str(heights(z)),'m/Shao_model_output.png']);
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



