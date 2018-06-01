clear all;
addpath('A-weighting_filter');

%-----------------START sta³e-------------
p0 = 2e-5; %ciœnienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta³ych-------------


%//////////////////////////////////////////////////generuj sygna³ testowy
time = 5; %dlugoœæ sygna³u w sekundach
Fs = 48000; %czêstotliwoœæ próbkowania
p = zeros(Fs*time,1); %inicjalizacja
amplitude = 0.1; %amplituda generowanego sygna³u
freq = 4e3;%czêstotliwoœæ generowanego sygna³u
for i = 1:time*Fs
    t = i * 1/Fs - 1/Fs;
    p(i) = amplitude * sin(freq*2*pi()*t);
end

%///////////////////////////////////// koniec generacji sygna³u wzorcowego



%--------------------- START ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F
pA = filterA(p, Fs);
p = (pA.^2)/(p0^2);%sta³a u³atwiaj¹ca dalsze obliczenia



%uœrednianie sygna³u dla sta³ej czasowej FAST:
nSamplesF = floor(F * Fs); %liczba próbek przypadaj¹ca na sta³¹ czasow¹, zaokr¹glenie w dó³

pAverage = p;
nF = floor(length(pA)/nSamplesF); % iloœæ oddzielnych uœrednionych wartoœci
pAverage = pAverage(1:nF*nSamplesF,1); %przyciêcie tabeli z próbkami do idealnej d³ugoœci, by zmieniæ kszta³t
pAverage = reshape(pAverage,nSamplesF,nF);
pAverage = mean(pAverage,1);

Lpa = 10 * log10(pAverage); %poziom ciœnienia akustycznego 

%u¿ywane do wykreœlenia poziomu, powiela wyniki co sta³¹ czasow¹ F
yLaf = pA;
for i = 1:nF
    for k = 1:nSamplesF
       
       yLaf((i-1)*nSamplesF + k,1)= Lpa(1,i);
    end
end
yLaf = yLaf(1:nF*nSamplesF);

%--------------------- KONIEC ------ poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F




%--------------------------------------START równowa¿ny poziom dŸwiêku A
T = 1; %czas obserwacji
nSamplesT = floor(T * Fs); %iloœæ próbek przypadaj¹ca na czas obserwacji, zaokr¹glenie w dó³
sampleTime = 1/Fs; %czas trwania jednej próbki
nT = floor(length(pA)/nSamplesT); % iloœæ odddzielnych sca³kowanych wartoœci
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
yLaqt = pA;
for i = 1:nT
    for k = 1:nSamplesT  
       n = (i-1)*nSamplesT + k; %przetwarzana próbka
       if(n > length(yLaqt)), continue; end
       yLaqt(n,1)= Laeq(i);
    end
end
yLaqt = yLaqt(1:nT*nSamplesT);
%--------------------------------------KONIEC równowa¿ny poziom dŸwiêku A

%--------------------------------------START poziom A ekspozycji na dŸwiêk


%--------------------------------------KONIEC poziom A ekspozycji na dŸwiêk







%wyœwietl ca³oœæ na 3 wykresach:
figure;
subplot(3,1,1);
plot(yLaf);
title('poziom dŸwiêku A uœredniony wed³ug charakterystyki czasowej F')
subplot(3,1,2);
plot(yLaqt);
string = ['równowa¿ny poziom dŸwiêku A dla T=', num2str(T)];
title(string);



