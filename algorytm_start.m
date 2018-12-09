clear all;
addpath('A-weighting_filter');

%-----------------START sta³e-------------
p0 = 2e-5; %ciœnienie odniesienia
F = 0.125; %stala czasowa fast
RMSwindow = 240; %okno dla liczenia RMS - ilosc próbek
a = 24; b = 0.04; %wspó³czynniki do uœredniania czasowego
%----------------KONIEC sta³ych-------------


%//////////////////////////////////////////////////generuj sygna³ testowy
endTime = 5; %dlugoœæ sygna³u w sekundach
Fs = 48000; %czêstotliwoœæ próbkowania
p = zeros(Fs*endTime,1); %inicjalizacja
amplitude = 0.1; %amplituda generowanego sygna³u
freq = 4e3;%czêstotliwoœæ generowanego sygna³u
for i = 1:endTime*Fs
    t = i * 1/Fs - 1/Fs;
    p(i) = amplitude * sin(freq*2*pi()*t);  
end
%///////////////////////////////////// koniec generacji sygna³u wzorcowego

pInput = p; %kopia sygna³u wejœciowego

%--------------------- START ------ poziom dŸwiêku uœredniony wed³ug charakterystyki czasowej F

p = (p.^2)/(p0^2);%sta³a u³atwiaj¹ca dalsze obliczenia

%-----------------obliczanie RMS:
RMSvalues = endTime*Fs / RMSwindow;
yRMS= reshape(p,RMSwindow,RMSvalues);%w kolumnach poszczególne wartoœci y do oddzielnych RMS
yRMS = rms(yRMS,1);
%-----------------KONIEC obliczanie RMS

%-------------START uœrednianie sygna³u dla sta³ej czasowej FAST:
last = 0; 
yRMS_F = zeros(RMSvalues,1);
for sample = 1:RMSvalues
   if sample ~= 1,last = yRMS_F(sample - 1);end
   now = yRMS(sample);
   yRMS_F(sample) = (a*last+now)*b;
end
%-------------KONIEC uœrednianie sygna³u dla sta³ej czasowej FAST

Lf = 10 * log10(yRMS_F/p0^2); %poziom ciœnienia akustycznego uœredniony wg sta³ej czasowej F

%u¿ywane do wykreœlenia poziomu, powiela wyniki co okno RMS
outLf = zeros(Fs*endTime,1);
for i = 1:RMSvalues
    outLf((i-1)*RMSwindow+1 : i*RMSwindow) = ones(RMSwindow,1)*Lf(i);
end
%--------------------- KONIEC ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F




%--------------------------------------START równowa¿ny poziom dŸwiêku A
T = 1; %czas obserwacji
nSamplesT = floor(T * Fs); %iloœæ próbek przypadaj¹ca na czas obserwacji, zaokr¹glenie w dó³
sampleTime = 1/Fs; %czas trwania jednej próbki
nT = floor(length(p)/nSamplesT); % iloœæ odddzielnych sca³kowanych wartoœci
Laeq = zeros(nT,1);
Ea = 0; %wartoœæ ca³ki w wyznaczonym przedziale - ekspozycja a na dŸwiêk

%ca³kowanie, dla ka¿dego z przedzia³ów:
for i = 1:nT
    for k = 1:nSamplesT
        n = (i-1)*nSamplesT + k; %przetwarzana próbka
        if(n+1 > length(p)),continue;end %ochrona przed wyjœciem za wektor
        Ea = Ea + sampleTime * p(n);
    end
    Laeq(i) = 10 * log10(1/T * Ea); %obliczanie poziomu równowa¿nego
    Ea = 0;
end


%u¿ywane do wykreœlenia poziomu, powiela wyniki co sta³¹ czasow¹ T
outLaeq = zeros(nT*nSamplesT,1);
for i = 1:nT
    outLaeq((i-1)*nSamplesT +1 : i*nSamplesT) = Laeq(i) * ones(nSamplesT,1);
end
%--------------------------------------KONIEC równowa¿ny poziom dŸwiêku A

%--------------------------------------START poziom A ekspozycji na dŸwiêk


%--------------------------------------KONIEC poziom A ekspozycji na dŸwiêk

time = 1/Fs : 1/Fs : endTime;
%wyœwietl ca³oœæ na 3 wykresach:
figure;
subplot(3,1,1);
plot(time, outLf);
title('poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F')
subplot(3,1,2);
plot(time, outLaeq);
string = ['równowa¿ny poziom dŸwiêku A dla T=', num2str(T)];
title(string);


%subplot(3,1,3);
figure;
subplot(211);
plot(time(1:100),pInput(1:100));
title('sygnal wejsciowy');

subplot(212);
plot(time(1:100),yRMS(1:100));
title('RMS sygna³ wejœciowy');
%dla sprawdzenia Lf wg rozporz¹dzenia ministra
%close all;
%maxLf = max(Lf);
%plot(time(1:Fs),outLf(1:Fs)-maxLf);


