%Example code for loading FLIR IR data
%Need to download Flir SDK -> Windows only I believe
%Probably a way to make it work on Mac if we think a bit

%Loads data into 3d matrix of frames
%Loads meta data into structure

%Options
%       unit;					% Unit to output (counts, radianceUser, temperatureUser, objectSignal, radianceFactory, temperatureFactory)
%		temperatureType;		% Temperature type to output (celsius, fahrenheit, kelvin, rankine)
%		applyNuc;				% Apply non-uniformity correction (0, 1)
%		applyBadPixels;			% Apply bad pixel replacement (0, 1)
%		applySuperfame;			% Collapse subframes into a superframe (0, 1)
%		objectParameters;		% Save Object Parameter structure (0, 1)

close all; clc; clear

%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUTS
    %%%%%%%%
    %Options for Loading data
        unit = 'temperatureFactory';
        temperatureType = 'kelvin';
        applyNuc = 0;
        applyBadPixels = 0;
        applySuperframe = 0;
        objectParameters = 1;
        %Change Object Parameters from default if objectParameters == 1
            objectParameters.emissivity = 1;
            objectParameters.distance = 1;
            objectParameters.reflectedTemp = 293.15;
            objectParameters.atmosphereTemp = 293.15;
            objectParameters.extOpticsTemp = 293.15;
            objectParameters.extOpticsTransmission = 1;
            objectParameters.estAtmosphericTransmission = 0;
            objectParameters.atmosphericTransmission = 1;
            objectParameters.relativeHumidity = 0;
    %Options for Loading data
    %%%%%%%%
    file = 'G:\FLIR DATA 19 oct 2017\Expensive-000012-292_10_48_53_907.ats';
    %file = '/Volumes/ACHILLIES/FLIR DATA 19 oct 2017/Expensive-000012-292_10_48_53_907.ats';
    freq = 10; %Frequency of data collection (Hz)
    startTime = 0; %start time relative to start of file (s)
    endTime = 5*60; %end time relative to start of file (s)
    timeSkip = 0; %time to skip between frames (s)
    MetaDataFreq = 5*60; %frequency with which to save meta data (s)
%INPUTS    
%%%%%%%%%%%%%%%%%%%%%%%%%


%Load image sequence object and apply obtions specified above
Image_Seq = FlirMovieReader(file);
Image_Seq.unit = unit;
Image_Seq.temperatureType = temperatureType;
Image_Seq.applyNuc = logical(applyNuc);
Image_Seq.applyBadPixels = logical(applyBadPixels);
Image_Seq.applySuperfame = logical(applySuperframe);

%Save object parameter structure 
if objectParameters
    Params = fieldnames(Image_Seq.objectParameters);
    for ii=length(Params)
        Image_Seq.objectParameters.(Params{ii}) = objectParameters.(Params{ii});
    end
end

%convert Time to frames
startFrame = startTime*freq;
endFrame = endTime*freq;
MetaFrameFreq = MetaDataFreq*freq;
frameSkip = timeSkip*freq+1;

cntr = 1;       %counter for saving frames
cntrMeta = 1;   %counter for saving metaData

%Initialize frame matrix
frame = zeros(512, 640, length(startFrame:frameSkip:endFrame));
tic;
%Save Frames and Metadata to variables
for ii=startFrame:frameSkip:endFrame
    if ~mod(ii, MetaFrameFreq)
        [frame(:, :, cntr), metaData{cntrMeta}] = step(Image_Seq, ii);
        cntr = cntr+1;
        cntrMeta = cntrMeta+1;
    else
        [frame(:, :, cntr), ~] = step(Image_Seq, ii);
        cntr = cntr+1;
    end
end
toc;

%%%%%%%%%%%%%%%
%Create and play movie
% % 
% % for ii=1:size(frame,3)
% %     imagesc(frame(:, :, ii))
% %     drawnow
% %     F(ii) = getframe;
% % end
% % movie(F)
