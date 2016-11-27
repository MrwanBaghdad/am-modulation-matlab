fs = 48*10^3;
wav = audioread('eric.wav');
wav = wav';
plot(wav);
ft = linspace(-fs/2,fs/2,length(wav))
spct = abs(fft(wav));
spct = fftshift(spct);
plot(spct);

l = length(wav)
iFilter = zeros(1,l);
decPoint = 4e3/48e3;
fCut = decPoint * l/2;
iFilter[l/2-fCut : l/2+fCut] = 1;

xdFilter = fftshift(abs(fft(iFilter)));

fwave = xdFilter .* wav;
plot(ft, fwave);

nwav = real(ifft(fwave));

plot(ft,nwav)
sound(nwav)


nwav = resample(5*100e3);
t=linspace(0,length(wav)*1/fs,length(nwav));
carrierF = cos(2*pi*100e3*t);

modsignal=nwav*carrierF;




