% fs = 48*10^3;
% wav = audioread('D:\uni\code\analog\eric.wav');
% wav = wav';
% plot(wav);
% ft = linspace(-fs/2,fs/2,length(wav));
% spct = fftshift(fft(wav));
% figure
% plot(ft, real(spct));

% l = length(wav);
% iFilter = zeros(1,l);
% decPoint = 4e3/48e3;
% fCut = decPoint * l/2;
% iFilter(l/2-fCut : l/2+fCut) = 1;

% xdFilter = fftshift(abs(fft(iFilter)));

% fwave = iFilter .* spct;
% figure
% plot(ft, fwave);

% nwav = ifft(ifftshift(fwave));
% nwav = real(nwav);
% owav = real(nwav);
% figure
% plot(owav);
% sound(owav,fs);


%Phase II%%%%%%%%%%%%%%%%%%%%%%%
ft = resample(ft, 5e5, 48e3);  
nwav = resample(owav, 5e5, 48e3);
t = linspace(0, length(wav)*1/fs, length(nwav));
carrierF = cos(2*pi*100e3.*t);

modsignal = nwav .* carrierF;


%Phase III %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default resampling




n0db  = awgn(modsignal, 0);
n10db = awgn(modsignal,10);
n30db = awgn(modsignal,30);


demod0db  = n0db .* carrierF;
demod10db = n10db .* carrierF;
demod30db = n30db .* carrierF;



% % downsampling
ft = resample(ft, 48e3, 5e5);  
ft = ft(1:length(owav));
% demod0db  = resample(demod0db, 48e3, 5e5);
% demod10db = resample(demod10db, 48e3, 5e5);
demod30db = resample(demod30db, 48e3, 5e5);

% demod0db  = demod0db(1:length(iFilter));
% demod10db = demod10db(1:length(iFilter));
demod30db = demod30db(1:length(iFilter));

%error mirror signal in lower spct !!!!

% % % demod0db  = fftshift(fft(demod0db))  .* xdFilter;
% % % demod10db = fftshift(fft(demod10db)) .* xdFilter;
demod30db = (abs(fftshift(fft(demod30db))));
demod30db  = demod30db .* iFilter;
plot(real(demod30db));

%TODO remove the mirror 
% % % demod0db  = ifft(ifftshift(demod0db));
% % % demod10db = ifft(ifftshift(demod10db));
demod30db = ifft(ifftshift(demod30db));
sound(real(demod30db),fs);

% plot(demod30db);
% % % sound(demod0db);