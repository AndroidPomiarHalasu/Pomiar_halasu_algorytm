clear all;
addpath('A-weighting_filter');

%-----------------START sta�e-------------
p0 = 2e-5; %ci�nienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta�ych-------------


%//////////////////////////////////////////////////generuj sygna� testowy
time = 5; %dlugo�� sygna�u w sekundach
Fs = 48000; %cz�stotliwo�� pr�bkowania
p = zeros(Fs*time,1); %inicjalizacja
amplitude = 0.1; %amplituda generowanego sygna�u
freq = 4e3;%cz�stotliwo�� generowanego sygna�u
for i = 1:time*Fs
    t = i * 1/Fs - 1/Fs;
    p(i) = amplitude * sin(freq*2*pi()*t);
end

%///////////////////////////////////// koniec generacji sygna�u wzorcowego



%--------------------- START ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F
pA = filterA(p, Fs);
p = (pA.^2)/(p0^2);%sta�a u�atwiaj�ca dalsze obliczenia



%u�rednianie sygna�u dla sta�ej czasowej FAST:
nSamplesF = floor(F * Fs); %liczba pr�bek przypadaj�ca na sta�� czasow�, zaokr�glenie w d�

pAverage = p;
nF = floor(length(pA)/nSamplesF); % ilo�� oddzielnych u�rednionych warto�ci
pAverage = pAverage(1:nF*nSamplesF,1); %przyci�cie tabeli z pr�bkami do idealnej d�ugo�ci, by zmieni� kszta�t
pAverage = reshape(pAverage,nSamplesF,nF);
pAverage = mean(pAverage,1);

Lpa = 10 * log10(pAverage); %poziom ci�nienia akustycznego 

%u�ywane do wykre�lenia poziomu, powiela wyniki co sta�� czasow� F
yLaf = pA;
for i = 1:nF
    for k = 1:nSamplesF
       
       yLaf((i-1)*nSamplesF + k,1)= Lpa(1,i);
    end
end
yLaf = yLaf(1:nF*nSamplesF);

%--------------------- KONIEC ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F




%--------------------------------------START r�wnowa�ny poziom d�wi�ku A
T = 1; %czas obserwacji
nSamplesT = floor(T * Fs); %ilo�� pr�bek przypadaj�ca na czas obserwacji, zaokr�glenie w d�
sampleTime = 1/Fs; %czas trwania jednej pr�bki
nT = floor(length(pA)/nSamplesT); % ilo�� odddzielnych sca�kowanych warto�ci
Laeq = zeros(nT,1);
Ea = 0; %warto�� ca�ki w wyznaczonym przedziale - ekspozycja a na d�wi�k

%ca�kowanie, dla ka�dego z przedzia��w:
for i = 1:nT
    for k = 1:nSamplesT
        n = (i-1)*nSamplesT + k; %przetwarzana pr�bka
        if(n+1 > length(p)),continue;end %ochrona przed wyj�ciem za wektor
        Ea = Ea + sampleTime * p(n);
    end
    Laeq(i) = 10 * log10(1/T * Ea); %obliczanie poziomu r�wnowa�nego
    Ea = 0;
end


%u�ywane do wykre�lenia poziomu, powiela wyniki co sta�� czasow� T
yLaqt = pA;
for i = 1:nT
    for k = 1:nSamplesT  
       n = (i-1)*nSamplesT + k; %przetwarzana pr�bka
       if(n > length(yLaqt)), continue; end
       yLaqt(n,1)= Laeq(i);
    end
end
yLaqt = yLaqt(1:nT*nSamplesT);
%--------------------------------------KONIEC r�wnowa�ny poziom d�wi�ku A

%--------------------------------------START poziom A ekspozycji na d�wi�k


%--------------------------------------KONIEC poziom A ekspozycji na d�wi�k







%wy�wietl ca�o�� na 3 wykresach:
figure;
subplot(3,1,1);
plot(yLaf);
title('poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F')
subplot(3,1,2);
plot(yLaqt);
string = ['r�wnowa�ny poziom d�wi�ku A dla T=', num2str(T)];
title(string);



