%algorytm nie stosuje korekcji A i dzia�a na wej�ciowym sygnale RMS !!!

clear all;


%-----------------START sta�e-------------
endTime = 0.02; %dlugo�� sygna�u w sekundach
stepTime = 0.005;%d�ugo�� skoku
stepStartTime = 0.002;%czas startu skoku

p0 = 2e-5; %ci�nienie odniesienia
F = 0.125; %stala czasowa fast
a = 24; b = 0.04; %wsp�czynniki do u�redniania czasowego
Fs = 48000; %cz�stotliwo�� pr�bkowania
%----------------KONIEC sta�ych-------------

%//////////////////////////////////////////////////generuj skok

samples = endTime *Fs;%ilo�� wszystkich pr�bek

inputRMS = zeros(Fs*endTime,1); %inicjalizacja
amplitude = 0.01; %amplituda generowanego sygna�u


stepStartSample = stepStartTime * Fs;
stepEndSample = stepStartSample + stepTime*Fs;

for i = stepStartSample:stepEndSample
    inputRMS(i) = amplitude;
end
%///////////////////////////////////// koniec generacji skoku


%-------------START u�rednianie sygna�u dla sta�ej czasowej FAST:
last = 0; 
inputRMS_F = zeros(samples,1);
for sample = 1:samples
   if sample ~= 1,last = inputRMS_F(sample - 1);end
   now = inputRMS(sample);
   inputRMS_F(sample) = (a*last+now)*b;
end
%-------------KONIEC u�rednianie sygna�u dla sta�ej czasowej FAST

Lf = zeros(samples,1);
for sample = 1:samples
    if inputRMS_F(sample) < p0^2, Lf(sample) = 0;
    else Lf(sample) = 10 * log10(inputRMS_F(sample)/p0^2); %poziom ci�nienia akustycznego u�redniony wg sta�ej czasowej F
    end
end



figure;
subplot(211);
plot(1:samples,inputRMS);
title('sygna� RMS wej�ciowy');

subplot(212);
plot(1:samples,inputRMS_F);
title('sygna� RMS wej�ciowy po u�rednieniu sta�� czasow� F');

figure;
subplot(211);
plot(1:samples,Lf);
title('poziom ci�nienia akustycznego u�redniony wg sta�ej czasowej F');


%----------------------------Sprawdzanie odpowiedzi z danymi referencyjnymi
load('referenceData/conventionalMeterReference.mat');



