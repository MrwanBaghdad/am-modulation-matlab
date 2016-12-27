fs = 48*10^3;
wav = audioread('eric.wav');
wav = wav';
ft = linspace(-fs/2,fs/2,length(wav));
spct = fftshift(fft(wav));


l = length(wav);
iFilter = zeros(1,l);
decPoint = 4e3/48e3;
fCut = decPoint * l/2;
iFilter(l/2-fCut : l/2+fCut) = 1;

xdFilter = fftshift(abs(fft(iFilter)));

fwave = iFilter .* spct;


nwav = ifft(ifftshift(fwave));
nwav = real(nwav);
owav = real(nwav);

figure;
subplot(2,1,1);
title('time domain filterd signal');
plot(owav);
subplot(2,1,2);
title('freq domain filtered signal')
plot(ft,fwave);

%Phase II%%%%%%%%%%%%%%%%%%%%%%%
ft = resample(ft, 5e5, 48e3);  
nwav = resample(owav, 5e5, 48e3);
t = linspace(0, length(wav)*1/fs, length(nwav));
carrierF = cos(2*pi*100e3.*t);
modsignal = nwav .* carrierF;



% Phase III %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default resampling

n0db  = awgn(modsignal, 0 , 'measured');
n10db = awgn(modsignal, 10, 'measured');
n30db = awgn(modsignal, 30, 'measured');

demod0db  = n0db .* carrierF;
demod10db = n10db .* carrierF;
demod30db = n30db .* carrierF;


% downsampling
fx = resample(ft, 48e3, 5e5);  
fx = fx(1:length(owav));
demod0db  = resample(demod0db, 48e3, 5e5);
demod10db = resample(demod10db, 48e3, 5e5);
demod30db = resample(demod30db, 48e3, 5e5);

demod0db  = demod0db(1:length(iFilter));
demod10db = demod10db(1:length(iFilter));
demod30db = demod30db(1 : length(iFilter));

filtered0db  = (fftshift(fft(demod0db)))  .* iFilter;
filtered10db = (fftshift(fft(demod10db))) .* iFilter;
filtered30db = ((fftshift(fft(demod30db)))) .* iFilter;


sound0db  = ifft(ifftshift(filtered0db));
sound10db= ifft(ifftshift(filtered10db));
sound30db= ifft(ifftshift(filtered30db));


figure;
subplot(2,1,1);
plot(fx,real(filtered0db));
title('0db spectrum')
subplot(2,1,2);
plot(real(sound10db));
title('0db time domain')

figure;
subplot(2,1,1);
plot(fx,real(filtered10db))
title('10db spectrum');
subplot(2,1,2);
plot(real(sound10db));
title('10db time domain');

figure;
subplot(2,1,1);
plot(fx,real(filtered30db));
title('30db spectrum');
subplot(2,1,2);
plot(real(sound30db));
title('30db time domain');
 

% %%%out sound
% sound(real(sound0db),fs);
% sound(real(sound10db),fs);
% sound(real(sound30db),fs);



% %%with Fc = 100.1 khz 
carrierErr = cos(2*pi*100.1e3.*t);
demod10db_err  = n10db .* carrierErr;
demod10db_err = resample(demod10db_err, 48e3, 5e5);
demod10db_err = demod10db_err(1: length(iFilter));
filtered10db_err = (fftshift(fft(demod10db_err))).* iFilter;
sound10db_err = ifft(ifftshift(filtered10db_err));
% % sound(real(sound10db_err),fs);

% %%%with phase error of 20 
carrierPhaseErr = cos(2*pi*100e3*(t + 20));
demod_phaseErr = n10db .* carrierPhaseErr;
demod_phaseErr = resample(demod_phaseErr, 48e3, 5e5);
demod_phaseErr = demod_phaseErr(1:length(iFilter));
filtered_phaseErr = fftshift(fft(demod_phaseErr)) .* iFilter;
sound_filtered_phaseErr = ifft(ifftshift(filtered_phaseErr));
% % sound(real(sound_filtered_phaseErr),fs);
