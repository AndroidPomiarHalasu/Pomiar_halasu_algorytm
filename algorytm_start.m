clear all;
addpath('A-weighting_filter');
%wykresy
plotLaf = 0; %poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F
plotLaqt = 0; %równowa¿ny poziom dŸwiêku A


%-----------------START sta³e-------------
p0 = 2e-5; %ciœnienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta³ych-------------


[y,Fs] = audioread('applause.wav');
%[y,Fs] = audioread('muscle-car.wav');
time = length(y)/Fs;



%--------------------- START ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F
yA = filterA(y, Fs);
p = (yA.^2)/(p0^2);%sta³a u³atwiaj¹ca dalsze obliczenia

Lpa = 10 * log(p); %poziom ciœnienia akustycznego 

%uœrednianie sygna³u dla sta³ej czasoej FAST:
nSamplesF = floor(F * Fs); %liczba próbek przypadaj¹ca na sta³¹ czasow¹, zaokr¹glenie w dó³

Laf = Lpa;
nF = floor(length(yA)/nSamplesF); % iloœæ oddzielnych uœrednionych wartoœci
Laf = Laf(1:nF*nSamplesF,1); %przyciêcie tabeli z próbkami do idealnej d³ugoœci, by zmieniæ kszta³t
Laf = reshape(Laf,nSamplesF,nF);
Laf = mean(Laf,1);

%yAverage  RMS ???


%u¿ywane do wykreœlenia poziomu, powiela wyniki co sta³¹ czasow¹ F
yLaf = yA;
for i = 1:nF
    for k = 1:nSamplesF
       
       yLaf((i-1)*nSamplesF + k,1)= Laf(1,i);
    end
end
yLaf = yLaf(1:nF*nSamplesF);

%--------------------- KONIEC ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F



if (plotLaf)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yNew)
    %sound(y,Fs)%odtwórz 
end

%--------------------------------------START równowa¿ny poziom dŸwiêku A
T = 0.4; %czas obserwacji
nSamplesT = floor(T * Fs); %iloœæ próbek przypadaj¹ca na czas obserwacji, zaokr¹glenie w dó³
sampleTime = 1/Fs; %czas trwania jednej próbki
nT = floor(length(yA)/nSamplesT); % iloœæ odddzielnych sca³kowanych wartoœci

%ca³kowanie, dla ka¿dego z przedzia³ów:

integrateT = 0; %wartoœæ ca³ki w wyznaczonym przedziale
Laqt = zeros(nT,1);%poziom równowa¿ny

for i = 1:nT
    for k = 1:nSamplesT
        n = (i-1)*nSamplesT + k; %przetwarzana próbka
        if(n+1 > length(p)),continue;end %ochrona przed wyjœciem za wektor
        integrateT = integrateT + sampleTime * (p(n+1)+p(n))/2;%ca³kowanie trapezami
    end
    Laqt(i) = 10 * log(1/sampleTime * integrateT); %obliczanie poziomu równowa¿nego
    integrateT = 0;
end
%u¿ywane do wykreœlenia poziomu, powiela wyniki co sta³¹ czasow¹ T
yLaqt = yA;
for i = 1:nT
    for k = 1:nSamplesT  
       n = (i-1)*nSamplesT + k; %przetwarzana próbka
       if(n > length(yLaqt)), continue; end
       yLaqt(n,1)= Laqt(i);
    end
end
yLaqt = yLaqt(1:nT*nSamplesT);
if (plotLaqt)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yLaqt)
    %sound(y,Fs)%odtwórz 
end
%--------------------------------------KONIEC równowa¿ny poziom dŸwiêku A

%wyœwietl ca³oœæ na 3 wykresach:
figure;
subplot(3,1,1);
plot(yLaf);
title('poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F')
subplot(3,1,2);
plot(yLaqt);
title('równowa¿ny poziom dŸwiêku A');



