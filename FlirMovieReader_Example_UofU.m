%Sample FlirMovieReader Code
%Problem with adjusting objectParameters

file = '*/*.ats';


%Load image sequence object and apply obtions specified above
Image_Seq = FlirMovieReader(file);

%Options for Loading data
Image_Seq.unit = 'temperatureFactory';
Image_Seq.temperatureType = 'kelvin';
Image_Seq.applyNuc = 0;
Image_Seq.applyBadPixels = 0;
Image_Seq.applySuperframe = 0;

%Change Object Parameters from default
%%%%%%%%%%%%%%%%%%%%%%
    %These values do not update in the structure
    Image_Seq.objectParameters.emissivity = 0;
    Image_Seq.objectParameters.distance = 1;
    Image_Seq.objectParameters.reflectedTemp = 293.15;
    Image_Seq.objectParameters.atmosphereTemp = 293.15;
    Image_Seq.objectParameters.extOpticsTemp = 293.15;
    Image_Seq.objectParameters.extOpticsTransmission = 1;
    Image_Seq.objectParameters.estAtmosphericTransmission = 1;
    Image_Seq.objectParameters.atmosphericTransmission = 1;
    Image_Seq.objectParameters.relativeHumidity = 0;
%%%%%%%%%%%%%%%%%%%%%%


