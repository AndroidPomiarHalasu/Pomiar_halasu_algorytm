%algorytm nie stosuje korekcji A

clear all;

%-----------------START sta³e-------------
endTime = 4; %dlugoœæ sygna³u w sekundach
stepTime = 1;%d³ugoœæ skoku
stepStartTime = 1;%czas startu skoku

p0 = 2e-5; %ciœnienie odniesienia
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



%--------------------------------------START równowa¿ny poziom dŸwiêku 
observationTime = 3; %czas obserwacji
observationSamples = floor(observationTime * Fs); %iloœæ próbek przypadaj¹ca na czas obserwacji, zaokr¹glenie w dó³
sampleTime = 1/Fs; %czas trwania jednej próbki
numberOfIntergations = floor(length(inputRMS)/observationSamples); % iloœæ odddzielnych sca³kowanych wartoœci
Laeq = zeros(numberOfIntergations,1);

sum=0;

for i = 1:samples
   
    if mod(i,observationSamples) == 0, sum = 0; end
    Lp = 10*log10((inputRMS(i)/p0)^2);
    sum = sum  + sampleTime * 10^(0.1*Lp);
    
    if sum < p0^2, Laeq(i) = 0;
    else
        Laeq(i) = 10 * log10(sum/observationTime); %obliczanie poziomu równowa¿nego
    end
    
end




figure;
subplot(211);
plot(1:samples,Laeq);




