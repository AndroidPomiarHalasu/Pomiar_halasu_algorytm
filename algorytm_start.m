clear all;
addpath('A-weighting_filter');


%-----------------START sta³e-------------
p0 = 2e-5; %ciœnienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta³ych-------------


[y,Fs] = audioread('applause.wav');
%[y,Fs] = audioread('muscle-car.wav');
time = length(y)/Fs;



%--------------------- START ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F
yA = filterA(y, Fs);

Lpa = 10 * log((yA.^2/(p0^2))); %poziom ciœnienia akustycznego 

%uœrednianie sygna³u dla sta³ej czasoej FAST:
nSamples = round(F * Fs); %liczba próbek przypadaj¹ca na sta³¹ czasow¹

Laf = Lpa;
n = round(length(yA)/nSamples); % iloœæ oddzielnych uœrednionych wartoœci
Laf = Laf(1:n*nSamples,1); %przyciêcie tabeli z próbkami do idealnej d³ugoœci, by zmieniæ kszta³t
Laf = reshape(Laf,nSamples,n);
Laf = mean(Laf,1);

%yAverage  RMS ???


%u¿ywane do wykreœlenia poziomu, powiela wyniki co sta³¹ czasow¹ F
yNew = yA;
for i = 1:n
    for k = 1:nSamples
       
       yNew((i-1)*nSamples + k,1)= Laf(1,i);
    end
end
yNew = yNew(1:n*nSamples);

%--------------------- KONIEC ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F

%--------------------------------------START równowa¿ny poziom dŸwiêku A



%--------------------------------------KONIEC równowa¿ny poziom dŸwiêku A

if (1)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yNew)
    %sound(y,Fs)%odtwórz 
end