%algorytm nie stosuje korekcji A

clear all;

%-----------------START sta�e-------------
endTime = 4; %dlugo�� sygna�u w sekundach
stepTime = 1;%d�ugo�� skoku
stepStartTime = 1;%czas startu skoku

p0 = 2e-5; %ci�nienie odniesienia
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



%--------------------------------------START r�wnowa�ny poziom d�wi�ku 
observationTime = 3; %czas obserwacji
observationSamples = floor(observationTime * Fs); %ilo�� pr�bek przypadaj�ca na czas obserwacji, zaokr�glenie w d�
sampleTime = 1/Fs; %czas trwania jednej pr�bki
numberOfIntergations = floor(length(inputRMS)/observationSamples); % ilo�� odddzielnych sca�kowanych warto�ci
Laeq = zeros(numberOfIntergations,1);

sum=0;

for i = 1:samples
   
    if mod(i,observationSamples) == 0, sum = 0; end
    Lp = 10*log10((inputRMS(i)/p0)^2);
    sum = sum  + sampleTime * 10^(0.1*Lp);
    
    if sum < p0^2, Laeq(i) = 0;
    else
        Laeq(i) = 10 * log10(sum/observationTime); %obliczanie poziomu r�wnowa�nego
    end
    
end




figure;
subplot(211);
plot(1:samples,Laeq);




