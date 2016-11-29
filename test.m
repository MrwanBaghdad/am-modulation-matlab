 fs = 48*10^3;
 wav = audioread('D:\College\Analogue\eric.wav');
 wav = wav';
 plot(wav);
 ft = linspace(-fs/2,fs/2,length(wav));
 spct = fftshift(fft(wav));
 figure
 plot(ft, real(spct));
 
 l = length(wav);
 iFilter = zeros(1,l);
 decPoint = 4e3/48e3;
 fCut = decPoint * l/2;
 iFilter(l/2-fCut : l/2+fCut) = 1;
 
 xdFilter = fftshift(abs(fft(iFilter)));
 
 fwave = iFilter .* spct;
 figure
 plot(ft, fwave);
 
 nwav = ifft(ifftshift(fwave));
 nwav = real(nwav);
 owav = real(nwav);
 figure
 plot(nwav);
sound(nwav,fs);


% TODO: resmapling  
nwav = resample(nwav,5*100e3,48000);
t = linspace(0,length(wav)*1/fs,length(nwav));
carrierF = cos(2*pi*100e3*t);

modsignal = nwav .*carrierF;

n0db = awgn(modsignal, 0);
n10db = awgn(modsignal,10);
n30db = awgn(modsignal,30);
% default resampling


% end TODO
figure
plot(n0db)
%sound(n0db)
figure
plot(n10db)
%sound(n10db)
figure
plot(n30db)
%sound(n30db)
% [n0db, n10db, n30db] = resample([n0db,n10db,n30db],48e3);


demod0db = n0db .* carrierF;
demod10db = n10db .* carrierF;
demod30db = n30db .* carrierF;

% downsampling
demod0db = resample(demod0db, 48e3, 100e3);
demod10db = resample(demod10db, 48e3, 100e3);
demod30db = resample(demod30db, 48e3, 100e3);

demod0db = demod0db(1:length(xdFilter));
demod10db = demod10db(1:length(xdFilter));
demod30db = demod30db(1:length(xdFilter));


demod0db = fftshift(abs(fft(demod0db)))   .* xdFilter;
demod10db = fftshift(abs(fft(demod10db))) .* xdFilter;
demod30db = fftshift(abs(fft(demod30db))) .* xdFilter;


demod0db = ifft(ifftshift(demod0db));
demod10db = ifft(ifftshift(demod10db));
demod30db = ifft(ifftshift(demod30db));

