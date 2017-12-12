function [emg1lpfilt emg2lpfilt] = FilterEMG(kEMG)
    %Cameron Snow, BU 12/12/17
    %Filter Design
    bpfilt = designfilt('bandpassiir','FilterOrder',20, ...
        'HalfPowerFrequency1',400,'HalfPowerFrequency2',3000, ...
        'SampleRate',24414.0625);


    lpfilt = designfilt('lowpassiir', 'PassbandFrequency', 40,...
                'StopbandFrequency', 12200, 'PassbandRipple',...
                1, 'StopbandAttenuation', 60, 'SampleRate', 24414.0625);

    emg1 = kEMG{4,1} - kEMG{3,1};
    emg2 = kEMG{2,1} - kEMG{1,1};

    emg1doub = double(emg1);
    emg2doub = double(emg2);

    %Bandpass Filter (400 Hz-->3000 Hz)
    emg1bpfilt = filter(bpfilt,emg1doub);
    emg2bpfilt = filter(bpfilt,emg2doub);

    %Rectification
    emg1abs = abs(emg1bpfilt);
    emg2abs = abs(emg2bpfilt);

    %Lowpass Filter (40 Hz)        
    emg1lpfilt = filter(lpfilt,emg1abs);
    emg2lpfilt = filter(lpfilt,emg2abs);
    
    %any remaining values that are above 20, set to zero
    %to do
    emg1lpfilt(emg1lpfilt > 20) = 1;
    emg2lpfilt(emg2lpfilt > 20) = 1;

    subplot(2,1,1)
    plot(emg1lpfilt)
    subplot(2,1,2)
    plot(emg2lpfilt)
end