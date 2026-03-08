clc; clear; close all;

%% DTMF Detection using FFT 

% 1) DTMF frequency sets
rowFreq = [697 770 852 941];
colFreq = [1209 1336 1477 1633];

% Keypad mapping (rows x cols)
keypad = ['1','2','3','A';
          '4','5','6','B';
          '7','8','9','C';
          '*','0','#','D'];

%% 2) User input digit (0-9 only)
keyIn = strtrim(input('Enter a digit (0-9): ','s'));

% Must be exactly one digit character
if length(keyIn) ~= 1 || ~ismember(keyIn, '0123456789')
    error('Enter only ONE digit from 0 to 9.');
end

key = keyIn(1);  % char

% Find row and column for the digit
[r, c] = find(keypad == key);
if isempty(r)
    error('Digit not found in keypad mapping (unexpected).');
end

f1 = rowFreq(r);
f2 = colFreq(c);

%% 3) Generate DTMF tone
Fs = 8000;
T  = 0.5;                       % duration in seconds
t  = (0:1/Fs:T-1/Fs)';

x = sin(2*pi*f1*t) + sin(2*pi*f2*t);

% Optional: listen to the clean tone
% soundsc(x, Fs);

%% 4) Add noise (optional)
noiseAmp = 0.05;
xn = x + noiseAmp*randn(size(x));

%% 5) Windowing + FFT
N = length(xn);
n = (0:N-1)';
w = 0.54 - 0.46*cos(2*pi*n/(N-1));   % Hamming window
xw = xn .* w;

Nfft = 2^nextpow2(N);
X = abs(fft(xw, Nfft));
f = (0:Nfft-1)*(Fs/Nfft);

% Use only half spectrum
half = 1:floor(Nfft/2);
f_half = f(half);
X_half = X(half);

%% 6) Detect row + column frequencies (check magnitudes at known DTMF freqs)
nearestMag = @(freq0) X_half( find(abs(f_half - freq0) == min(abs(f_half - freq0)), 1) );

rowMag = arrayfun(nearestMag, rowFreq);
colMag = arrayfun(nearestMag, colFreq);

[~, r_hat] = max(rowMag);
[~, c_hat] = max(colMag);

detectedKey = keypad(r_hat, c_hat);

%% 7) Print result
fprintf('\nOriginal digit: %c\n', key);
fprintf('Detected row freq: %d Hz\n', rowFreq(r_hat));
fprintf('Detected col freq: %d Hz\n', colFreq(c_hat));
fprintf('Detected digit: %c\n\n', detectedKey);
if detectedKey == key
    fprintf("Detection Successful \n");
else
    fprintf("Detection Failed \n");
end

%% 8) Plots (always refresh Figure 1 and Figure 2)
Ns = min(N, round(0.05*Fs));  % first 50 ms

% Time domain
figure(1); clf;
plot(t(1:Ns), xn(1:Ns), 'LineWidth', 1);
grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title(sprintf('Noisy DTMF Signal (Digit %c) - First 50 ms', key));
saveas(gcf, 'time_waveform.png');

% Frequency spectrum
figure(2); clf;
plot(f_half, 20*log10(X_half + 1e-12), 'LineWidth', 1);
grid on;
xlim([0 2000]);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title(sprintf('DTMF Spectrum (FFT) - Digit %c', key));
hold on;

% Mark detected frequencies (no xline needed)
yl = ylim;
plot([rowFreq(r_hat) rowFreq(r_hat)], yl, '--');
plot([colFreq(c_hat) colFreq(c_hat)], yl, '--');
legend('Spectrum','Detected Row','Detected Col');

saveas(gcf, 'spectrum.png');
