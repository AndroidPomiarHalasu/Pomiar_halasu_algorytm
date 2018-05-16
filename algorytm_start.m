clear all;
addpath('A-weighting_filter');
%wykresy
plotLaf = 0; %poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F
plotLaqt = 0; %r�wnowa�ny poziom d�wi�ku A


%-----------------START sta�e-------------
p0 = 2e-5; %ci�nienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta�ych-------------


[y,Fs] = audioread('applause.wav');
%[y,Fs] = audioread('muscle-car.wav');
time = length(y)/Fs;



%--------------------- START ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F
yA = filterA(y, Fs);
p = (yA.^2)/(p0^2);%sta�a u�atwiaj�ca dalsze obliczenia

Lpa = 10 * log(p); %poziom ci�nienia akustycznego 

%u�rednianie sygna�u dla sta�ej czasoej FAST:
nSamplesF = floor(F * Fs); %liczba pr�bek przypadaj�ca na sta�� czasow�, zaokr�glenie w d�

Laf = Lpa;
nF = floor(length(yA)/nSamplesF); % ilo�� oddzielnych u�rednionych warto�ci
Laf = Laf(1:nF*nSamplesF,1); %przyci�cie tabeli z pr�bkami do idealnej d�ugo�ci, by zmieni� kszta�t
Laf = reshape(Laf,nSamplesF,nF);
Laf = mean(Laf,1);

%yAverage  RMS ???


%u�ywane do wykre�lenia poziomu, powiela wyniki co sta�� czasow� F
yLaf = yA;
for i = 1:nF
    for k = 1:nSamplesF
       
       yLaf((i-1)*nSamplesF + k,1)= Laf(1,i);
    end
end
yLaf = yLaf(1:nF*nSamplesF);

%--------------------- KONIEC ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F



if (plotLaf)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yNew)
    %sound(y,Fs)%odtw�rz 
end

%--------------------------------------START r�wnowa�ny poziom d�wi�ku A
T = 0.4; %czas obserwacji
nSamplesT = floor(T * Fs); %ilo�� pr�bek przypadaj�ca na czas obserwacji, zaokr�glenie w d�
sampleTime = 1/Fs; %czas trwania jednej pr�bki
nT = floor(length(yA)/nSamplesT); % ilo�� odddzielnych sca�kowanych warto�ci

%ca�kowanie, dla ka�dego z przedzia��w:

integrateT = 0; %warto�� ca�ki w wyznaczonym przedziale
Laqt = zeros(nT,1);%poziom r�wnowa�ny

for i = 1:nT
    for k = 1:nSamplesT
        n = (i-1)*nSamplesT + k; %przetwarzana pr�bka
        if(n+1 > length(p)),continue;end %ochrona przed wyj�ciem za wektor
        integrateT = integrateT + sampleTime * (p(n+1)+p(n))/2;%ca�kowanie trapezami
    end
    Laqt(i) = 10 * log(1/sampleTime * integrateT); %obliczanie poziomu r�wnowa�nego
    integrateT = 0;
end
%u�ywane do wykre�lenia poziomu, powiela wyniki co sta�� czasow� T
yLaqt = yA;
for i = 1:nT
    for k = 1:nSamplesT  
       n = (i-1)*nSamplesT + k; %przetwarzana pr�bka
       if(n > length(yLaqt)), continue; end
       yLaqt(n,1)= Laqt(i);
    end
end
yLaqt = yLaqt(1:nT*nSamplesT);
if (plotLaqt)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yLaqt)
    %sound(y,Fs)%odtw�rz 
end
%--------------------------------------KONIEC r�wnowa�ny poziom d�wi�ku A

%wy�wietl ca�o�� na 3 wykresach:
figure;
subplot(3,1,1);
plot(yLaf);
title('poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F')
subplot(3,1,2);
plot(yLaqt);
title('r�wnowa�ny poziom d�wi�ku A');



