%algorytm nie stosuje korekcji A i dzia³a na wejœciowym sygnale RMS !!!

clear all;


%-----------------START sta³e-------------
endTime = 0.02; %dlugoœæ sygna³u w sekundach
stepTime = 0.005;%d³ugoœæ skoku
stepStartTime = 0.002;%czas startu skoku

p0 = 2e-5; %ciœnienie odniesienia
F = 0.125; %stala czasowa fast
a = 24; b = 0.04; %wspó³czynniki do uœredniania czasowego
Fs = 48000; %czêstotliwoœæ próbkowania
%----------------KONIEC sta³ych-------------

%//////////////////////////////////////////////////generuj skok

samples = endTime *Fs;%iloœæ wszystkich próbek

inputRMS = zeros(Fs*endTime,1); %inicjalizacja
amplitude = 0.01; %amplituda generowanego sygna³u


stepStartSample = stepStartTime * Fs;
stepEndSample = stepStartSample + stepTime*Fs;

for i = stepStartSample:stepEndSample
    inputRMS(i) = amplitude;
end
%///////////////////////////////////// koniec generacji skoku


%-------------START uœrednianie sygna³u dla sta³ej czasowej FAST:
last = 0; 
inputRMS_F = zeros(samples,1);
for sample = 1:samples
   if sample ~= 1,last = inputRMS_F(sample - 1);end
   now = inputRMS(sample);
   inputRMS_F(sample) = (a*last+now)*b;
end
%-------------KONIEC uœrednianie sygna³u dla sta³ej czasowej FAST

Lf = zeros(samples,1);
for sample = 1:samples
    if inputRMS_F(sample) < p0^2, Lf(sample) = 0;
    else Lf(sample) = 10 * log10(inputRMS_F(sample)/p0^2); %poziom ciœnienia akustycznego uœredniony wg sta³ej czasowej F
    end
end



figure;
subplot(211);
plot(1:samples,inputRMS);
title('sygna³ RMS wejœciowy');

subplot(212);
plot(1:samples,inputRMS_F);
title('sygna³ RMS wejœciowy po uœrednieniu sta³¹ czasow¹ F');

figure;
subplot(211);
plot(1:samples,Lf);
title('poziom ciœnienia akustycznego uœredniony wg sta³ej czasowej F');


%----------------------------Sprawdzanie odpowiedzi z danymi referencyjnymi
load('referenceData/conventionalMeterReference.mat');



