clear all;
addpath('A-weighting_filter');


%-----------------START sta�e-------------
p0 = 2e-5; %ci�nienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta�ych-------------


[y,Fs] = audioread('applause.wav');
time = length(y)/Fs;



%--------------------- START ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F
yFiltered = filterA(y, Fs);
%u�rednianie sygna�u dla sta�ej czasoej FAST:
nSamples = round(F * Fs); %liczba pr�bek przypadaj�ca na sta�� czasow�

yAverage = yFiltered;
n = round(length(y)/nSamples); % ilo�� oddzielnych u�rednionych warto�ci
yAverage = yAverage(1:n*nSamples,1); %przyci�cie tabeli z pr�bkami do idealnej d�ugo�ci, by zmieni� kszta�t
yAverage = reshape(yAverage,nSamples,n);
yAverage = mean(yAverage,1);



%--------------------- KONIEC ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F


if (1)
    
    plot(y)
    hold on
    plot(yFiltered)
    %sound(y,Fs)%odtw�rz 
end