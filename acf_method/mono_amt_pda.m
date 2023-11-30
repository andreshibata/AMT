%audiofile = 'audio/C_major.ogg';
audiofile = 'audio/twinkle.mp3';

[y,Fs] = audioread(audiofile);
% if stereo audio, take just one channel:
y = y(:,1);

% Twelve-tone equal temperament tuning has note frequencies about 26.16 Hz apart. We want to have FFT frequency resolution < 26 Hz:
% Fs/N < 26. For standard 44.1kHz, N = 1696, rounding up to power of 2: N =
% 2048. Resolution: 21.5 Hz. Going to oversample by a factor of 2 so N =
% 4096.

k = 2;
N = 2048*k;
L = N/2;
%raised cosine window
h = hann(L,'periodic');
%zero pad window
h = [h; zeros(N-L,1)];

freqs = [];
amps = [];

M = floor(length(y)/(L/2));
%zero pad last frame
paddingSize = M*L/2 + N - length(y);
y = [y; zeros(paddingSize,1)];

note_lut = readtable('note_lookup_table.csv','NumHeaderLines',1);

for j=0:M
    %segment audio into size L blocks with 50% overlap
    n = L/2*j+1:L/2*j+N;
    block = y(n);

    %compute ACF
    R = ifft(fft(block.*h).*conj(fft(block.*h)));

    %get average size of prominent ACF peaks
    [p,i] = findpeaks(R(1:N/2),1:N/2,"NPeaks",3,'SortStr','descend');
    mph = sum(p)/3;

    %ignore small peaks
    [p,i] = findpeaks(R(1:N/2),1:N/2,"NPeaks",1,'MinPeakHeight',mph);

    if length(i)==0
        i = 0;
    end

    freq = 1/(1/Fs*i)*2;
    
    amps = [amps p];
    freqs = [freqs freq];
end

% mph = mean(amps);
% [p,i] = findpeaks(amps,length(amps),"NPeaks",20,'SortStr','descend');
% mpp = mean(p)-mph;
mpp = mean(amps);

% a = ifft(fft(amps).*conj(fft(amps)));
% [p,i] = findpeaks(a,"NPeaks",1, 'SortStr', 'descend');


figure
subplot(1,2,1)
stem(1:length(freqs),freqs)
xlabel("Frame #")
ylabel("F_0 (Hz)")

subplot(1,2,2)
stem(1:length(amps),amps)
findpeaks(amps, 'MinPeakProminence',mpp)
xlabel("Frame #")   
ylabel("Amplitude")


%find note onsets from amplitude peaks
[pks,locs] = findpeaks(amps, 'MinPeakProminence',mpp);
locs = [locs length(amps)]; %for computation of last note duration
onsets = 1/Fs*L/2*locs;

%use mode to determine frequencies
fs = [];
for i=2:length(locs)-1
    f = mode(freqs(locs(i-1)+1:locs(i)));
    fs = [fs f];
end
fs = [fs mode(freqs(locs(i):end))];

%compute piano key index
keys = round(12*log2(fs/440)+49);
%lookup note label from piano key
notes = note_lut(keys,3);

table(notes,onsets(1:end-1)')

%convert difference in onset times to beats
beats = [];
for i=1:length(onsets)-1
    beat = ceil(onsets(i+1)-onsets(i));
    beats = [beats beat];
end

%lookup note in Lilypond format
notes = note_lut(keys,5);
%convert beats to duration
durations = num2str(4./beats');
plot_notes(string(notes{:,1}),durations)

%song = audioplayer(y,Fs)
%play(song)

% figure
% melSpectrogram(y,Fs, ...
%     "Window",hann(N,'periodic'), ...
%     "OverlapLength", N/2, ...
%     "FFTLength",N, ...
%     "NumBands",64, ...
%     "FrequencyRange",[62.5,20e3])
