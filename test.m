<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> parent of 5551cf9... fix syntax
% fs = 48*10^3;
% wav = audioread('D:\uni\code\analog\eric.wav');
% wav = wav';
% plot(wav);
% ft = linspace(-fs/2,fs/2,length(wav));
% spct = fftshift(fft(wav));
% figure
% plot(ft, real(spct));
% 
% l = length(wav);
% iFilter = zeros(1,l);
% decPoint = 4e3/48e3;
% fCut = decPoint * l/2;
% iFilter(l/2-fCut : l/2+fCut) = 1;
% 
% xdFilter = fftshift(abs(fft(iFilter)));
% 
% fwave = iFilter .* spct;
% figure
% plot(ft, fwave);
% 
% nwav = ifft(ifftshift(fwave));
% nwav = real(nwav);
% owav = real(nwav);
% figure
% plot(nwav);
% sound(nwav,fs);


% TODO: resmapling  
nwav = resample(nwav,5*100e3,48000);
t = linspace(0,length(wav)*1/fs,length(nwav));
carrierF = cos(2*pi*100e3*t);
=======
fs = 48*10^3;
wav = audioread('eric.wav');
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
plot(owav);
% sound(owav,fs);


% %Phase II%%%%%%%%%%%%%%%%%%%%%%%
ft = resample(ft, 5e5, 48e3);  
nwav = resample(owav, 5e5, 48e3);
t = linspace(0, length(wav)*1/fs, length(nwav));
carrierF = cos(2*pi*100e3.*t);
modsignal = nwav .* carrierF;
>>>>>>> origin/master

modsignal = nwav .*carrierF;

n0db = awgn(modsignal, 0);
n10db = awgn(modsignal,10);
n30db = awgn(modsignal,30);
% default resampling

<<<<<<< HEAD

% end TODO
plot(n0db)
% [n0db, n10db, n30db] = resample([n0db,n10db,n30db],48e3);
:q!

demod0db = n0db .* carrierF;
=======
n0db  = awgn(modsignal, 0 , 'measured');
n10db = awgn(modsignal, 10, 'measured');
n30db = awgn(modsignal, 30, 'measured');

demod0db  = n0db .* carrierF;

demod10db = n10db .* carrierF;
demod30db = n30db .* carrierF;

% downsampling
demod0db = resample(demod0db, 48e3, 100e3);
demod10db = resample(demod10db, 48e3, 100e3);
demod30db = resample(demld30db, 48e3, 100e3);

demod0db = demod0db(1:length(xdFilter));
demod10db = demod10db(1:length(xdFilter));
demod30db = demod30db(1:length(xdFilter));


demod0db = fftshift(abs(fft(demod0db)))   .* xdFilter;
demod10db = fftshift(abs(fft(demod10db))) .* xdFilter;
demod30db = fftshift(abs(fft(demod30db))) .* xdFilter;


demod0db = ifft(iffshift(demod0db));
demod10db = ifft(ifftshift(demod10db));
demod30db = ifft(ifftshift(demod30db));
=======
% % downsampling
fx = resample(ft, 48e3, 5e5);  
fx = fx(1:length(owav));
demod0db  = resample(demod0db, 48e3, 5e5);
demod10db = resample(demod10db, 48e3, 5e5);
demod30db = resample(demod30db, 48e3, 5e5);

demod0db  = demod0db(1:length(iFilter));
demod10db = demod10db(1:length(iFilter));
demod30db = demod30db(1 : length(iFilter));

filtered0db  = fftshift(fft(demod0db))  .* xdFilter;
filtered10db = fftshift(fft(demod10db)) .* xdFilter;
filtered30db = ((fftshift(fft(demod30db)))) .* iFilter;
plot(real(demod30db));

 
sound0db  = ifft(ifftshift(filtered0db));
sound10db= ifft(ifftshift(filtered10db));
sound30db= ifft(ifftshift(filtered30db));

%out sound
sound(real(sound0db),fs);
sound(real(sound10db),fs);
sound(real(sound30db),fs);



%% with Fc = 100.1 khz 
carrierErr = cos(2*pi*100.1e3*ft);
demod10db_err  = n10db .* carrierErr;
demod10db_err = resample(demod10db, 48e3, 5e3);
demod10db_err = demod10db_err(1: length(iFilter));
filtered10db_err = fftshift(fft(demod10db_err)).* iFilter;
sound10db_err = ifft(ifftshift(filtered10db_err));


%% with phase error of 20 
carrierPhaseErr = cos(2*pi*100e3*ft + 20);
demod_phaseErr = n10db .* carrierPhaseErr;
demod_phaseErr = resample(demod_phaseErr, 48e3, 5e3);
demod_phaseErr = demod_phaseErr(1:length(iFilter));
filtered_phaseErr = demod_phaseErr .* iFilter;
filtered_phaseErr = fftshift(fft(filtered_phaseErr));
sound_filtered_phaseErr = ifft(ifftshift(filtered_phaseErr));


