clear all;
addpath('A-weighting_filter');


%-----------------START sta³e-------------
p0 = 2e-5; %ciœnienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta³ych-------------


%[y,Fs] = audioread('applause.wav');
[y,Fs] = audioread('muscle-car.wav');
time = length(y)/Fs;



%--------------------- START ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F
yFiltered = filterA(y, Fs);
%uœrednianie sygna³u dla sta³ej czasoej FAST:
nSamples = round(F * Fs); %liczba próbek przypadaj¹ca na sta³¹ czasow¹

yAverage = yFiltered;
n = round(length(y)/nSamples); % iloœæ oddzielnych uœrednionych wartoœci
yAverage = yAverage(1:n*nSamples,1); %przyciêcie tabeli z próbkami do idealnej d³ugoœci, by zmieniæ kszta³t
yAverage = reshape(yAverage,nSamples,n);
yAverage = mean(yAverage,1);

%yAverage  RMS ???

Laf = 10 * log((yAverage/p0).^2); %poziom ciœnienia akustycznego 


yNew = yFiltered;
for i = 1:n
    for k = 1:nSamples
       
       yNew((i-1)*nSamples + k,1)= Laf(1,i);
    end
end
yNew = yNew(1:n*nSamples);

%--------------------- KONIEC ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F


if (1)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yNew)
    %sound(y,Fs)%odtwórz 
end