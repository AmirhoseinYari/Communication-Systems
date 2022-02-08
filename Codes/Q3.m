clc
clear all
close all

fs = 1e6;
TPulse = 10e-3;
fc = 10e3;
BW = 1e3;
Ts = 1/fs;

%% part 1
OneShape = ones(1,TPulse/Ts);
ZeroShape = -OneShape;

N = 1000; %length of massage b[n]
b = randi([0 1],1,N);
figure(1)
stem(b)
title('input b :')
ylabel('b[n]:')
xlabel('n')
xlim([0 100])

[b1, b2] = Divide(b);
figure(2)
subplot(2,1,1)
stem(b1)
xlim([0 50])
title('first part, b1 :')
subplot(2,1,2)
stem(b2)
title('second part b2 :')
xlim([0 50])

x1 = PulseShaping(b1,OneShape,ZeroShape);
x2 = PulseShaping(b2,OneShape,ZeroShape);
t = 0:Ts:(length(x1)-1)*Ts;
figure(3)
subplot(2,1,1)
plot(t,x1)
xlim([0 500e-3])
ylim([-2 2])
title('first part, x1 :')
subplot(2,1,2)
plot(t,x2)
title('second part, x2 :')
xlim([0 500e-3])
ylim([-2 2])

xc = AnalogMod(x1,x2,fs,fc);
figure(4)
subplot(2,1,1)
plot(t,xc)
xlim([0 50/fc])
ylim([-2 2])
title('xc befor channel :')

y = Channel(xc,fs,fc,BW);
subplot(2,1,2)
plot(t,y)
title('xc after channel :')
xlim([0 50/fc])
ylim([-2 2])

[y1, y2] = AnalogDemod(y,fs,BW,fc);
figure(5)
subplot(2,1,1)
plot(t,y1)
xlim([0 500e-3])
ylim([-2 2])
title('first part recived, y1 :')
subplot(2,1,2)
plot(t,y2)
title('second part recived, y2 :')
xlim([0 500e-3])
ylim([-2 2])

[one1, zero1, b1_hat] = MatchedFilt(y1, OneShape, ZeroShape);
[one2, zero2, b2_hat] = MatchedFilt(y2, OneShape, ZeroShape);
figure(6)
subplot(2,2,1)
plot(one1)
xlim([0 fs/2])
title('first part, oneMatched :')
subplot(2,2,2)
plot(zero1)
title('first part zeroMatched :')
xlim([0 fs/2])
subplot(2,2,3)
plot(one2)
xlim([0 fs/2])
title('second part, oneMatch :')
subplot(2,2,4)
plot(zero2)
title('second part zeroMatch :')
xlim([0 fs/2])

figure(7)
subplot(2,1,1)
stem(b1_hat)
xlim([0 50])
title('first part, b1-hat :')
subplot(2,1,2)
stem(b2_hat)
title('second part b2-hat :')
xlim([0 50])

b_hat = Combine(b1_hat,b2_hat);
figure(8)
subplot(2,1,1)
stem(b)
xlim([0 50])
title('Original message, b :')
subplot(2,1,2)
stem(b_hat)
title('Recieved message, b-hat :')
xlim([0 50])

fprintf('no noise finished, press enter to continue.');
pause;

%% AWGN for PAM
clc
close all

snr = 10:-10:-200;
error = zeros(1,length(snr));
for i = 1:1:length(snr)
    i
    N = 100;
    b = randi([0 1],1,N);
    [b1, b2] = Divide(b);
    x1 = PulseShaping(b1,OneShape,ZeroShape);
    x2 = PulseShaping(b2,OneShape,ZeroShape);
    xc = AnalogMod(x1,x2,fs,fc);
    y = Channel(xc,fs,fc,BW);
    y = awgn(y,snr(i));
    [y1, y2] = AnalogDemod(y,fs,BW,fc);
    [one1, zero1, b1_hat] = MatchedFilt(y1, OneShape, ZeroShape);
    [one2, zero2, b2_hat] = MatchedFilt(y2, OneShape, ZeroShape);
    b_hat = Combine(b1_hat,b2_hat);
    error(i) = sum(abs(b_hat-b))/N*100;
end

figure(1)
plot(snr,error)
title('error over snr :')














