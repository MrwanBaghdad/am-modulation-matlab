fs = 48*10^3;
wav = audioread('eric.wav');
wav = wav';
plot(wav);

spct = abs(fft(wav));
spct = fftshift(spct);
plot(spct);
