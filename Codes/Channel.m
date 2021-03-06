function y = Channel(xc, fs, fc, BW)
%y = 2*bandpass(xc,[fc-BW/2 fc+BW/2],fs,'Steepness',0.98);
y = 2*bandpass(xc,[fc-BW/2 fc+BW/2],fs,'Steepness',0.8); %for fsk
Xc = fftshift(fft(xc));
Y = fftshift(fft(y));

%figure
%N = length(xc);
%f =  (-N/2:N/2-1)*(fs/N);
%fmax = 2000;
%n = N*fmax/fs;
%subplot(2,1,1)
%plot(f(N/2-n:N/2+n),abs(Xc(N/2-n:N/2+n)))
%title('Received signal Fourier transform :')
%ylabel('Received(f)')
%xlabel('frequency')

%subplot(2,1,2)
%plot(f(N/2-n:N/2+n),abs(Y(N/2-n:N/2+n)))
%title('Filtered Received signal Fourier transform :')
%ylabel('Filtered-Received(f)')
%xlabel('frequency')
end