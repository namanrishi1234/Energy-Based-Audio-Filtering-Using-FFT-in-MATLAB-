function [] = func(str)

[x, Fs] = audioread(str);
if size(x, 2) > 1
    x = mean(x, 2);
end
N = length(x);
t = (0:N-1)/Fs;

figure;
plot(t, x);
title("Original Siginal in the Time Domain");
xlabel("t");
ylabel("x(t)");
xlim([0 max(max(t))]);

x0 = x - mean(x);
X = fft(x0);
Xmag = abs(X)/N;
f = (0:N-1)*(Fs/N);
half = 1:floor(N/2);

figure;
plot(f(half), Xmag(half));
title("Original Signal in the Frequency Domain");
xlabel("f");
ylabel("|X(f)|");

K = floor(N/2);
X1 = X(1:K+1);

E = abs(X1).^2;
Ecum = cumsum(E);
C = Ecum/Ecum(end);
a = 0.95;
kc = find(C >= a, 1, 'first');
k0 = kc - 1;
fc = (k0/N)*Fs;
fprintf("fc = %.2f Hz\n", fc);

y = lowpass(x, fc, Fs);
figure;
plot(t, y);
title("Lowpass-Filtered Signal in the Time Domain")
xlabel("t");
ylabel("y(t)");

Y = fft(y);
Y1 = Y(1:K+1);
f1 = (0:K)*(Fs/N);
Ymag = abs(Y1)/N;
figure;
plot(f1, Ymag);
title("Lowpass-Filtered Signal in the Frequency Domain");
xlabel("f");
ylabel("|X(f)||H(f)|");

z = highpass(x, fc, Fs);
figure;
plot(t, z);
title("Highpass-Filtered Signal in the Time Domain ");
xlabel("t");
ylabel("z(t)");

Z = fft(z);
Z1 = Z(1:K+1);
Zmag = abs(Z1)/N;
figure;
plot(f1, Zmag);
title("Highpass-Filtered Signal in the Frequency Domain");
xlabel("f");
ylabel("|X(f)||H(f)|");

audiowrite("lowpassed.wav", y, Fs);
audiowrite("highpassed.wav", z, Fs);

end