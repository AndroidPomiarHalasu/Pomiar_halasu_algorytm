clear all;
addpath('A-weighting_filter');

%-----------------START sta�e-------------
p0 = 2e-5; %ci�nienie odniesienia
F = 0.125; %stala czasowa fast
RMSwindow = 240; %okno dla liczenia RMS - 240 pr�bek
a = 24; b = 0.04; %wsp�czynniki do u�redniania czasowego
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

%-----------------obliczanie RMS:
RMSvalues = time*Fs / RMSwindow;
yRMS= reshape(pA,RMSwindow,RMSvalues);%w kolumnach poszczeg�lne warto�ci y do oddzielnych RMS
yRMS = rms(yRMS,1);
%-----------------KONIEC obliczanie RMS

%-------------START u�rednianie sygna�u dla sta�ej czasowej FAST:
last = 0; 
yRMS_F = zeros(RMSvalues,1);
for sample = 1:RMSvalues
   if sample ~= 1,last = yRMS_F(sample - 1);end
   now = yRMS(sample);
   yRMS_F(sample) = (a*last+now)*b;
end
%-------------KONIEC u�rednianie sygna�u dla sta�ej czasowej FAST

Lf = 10 * log10(yRMS_F.^2/p0^2); %poziom ci�nienia akustycznego u�redniony wg sta�ej czasowej F

%u�ywane do wykre�lenia poziomu, powiela wyniki co okno RMS
outLf = zeros(Fs*time,1);
for i = 1:RMSvalues
    outLf((i-1)*RMSwindow+1 : i*RMSwindow) = ones(RMSwindow,1)*Lf(i);
end
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
outLaeq = zeros(nT*nSamplesT,1);
for i = 1:nT
    outLaeq((i-1)*nSamplesT +1 : i*nSamplesT) = Laeq(i) * ones(nSamplesT,1);
end
%--------------------------------------KONIEC r�wnowa�ny poziom d�wi�ku A

%--------------------------------------START poziom A ekspozycji na d�wi�k


%--------------------------------------KONIEC poziom A ekspozycji na d�wi�k


%wy�wietl ca�o�� na 3 wykresach:
figure;
subplot(3,1,1);
plot(outLf);
title('poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F')
subplot(3,1,2);
plot(outLaeq);
string = ['r�wnowa�ny poziom d�wi�ku A dla T=', num2str(T)];
title(string);



