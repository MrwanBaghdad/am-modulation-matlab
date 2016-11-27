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

n0db = awgn(modsignal, 0);
n10db = awgn(modsignal,10);
n30db = awgn(modsignal,30);

n0db = resample(n0db,48e3);
n10db = resample(n10db,48e3);
n30db = resample (n30db, 48e3);



plot(t,[n0db,n10db,n30db])
% [n0db, n10db, n30db] = resample([n0db,n10db,n30db],48e3);

demod0db = n0db .* carrierF
demod10db = n10db .* carrierF
demod30db = n30db .* carrierF

demod0db = fftshift(abs(fft(demod0db)))   .* xdFilter
demod10db = fftshift(abs(fft(demod10db))) .* xdFilter
demod30db = fftshift(abs(fft(demod30db))) .* xdFilter


demod0db = ifft(real(demod0db))
demod10db = ifft(real(demod10db))
demod30db = ifft(real(demod30db))

