%algorytm nie stosuje korekcji A i dzia�a na wej�ciowym sygnale RMS !!!

clear all;


%-----------------START sta�e-------------
F = 0.125; %stala czasowa fast
a = 24; b = 0.04; %wsp�czynniki do u�redniania czasowego

endTime = 1; %dlugo�� sygna�u w sekundach

p0 = 2e-5; %ci�nienie odniesienia
Fs = 48000; %cz�stotliwo�� pr�bkowania

RMSwindow = 240;%okno rms (ilo�� pr�bek)

allSamples = endTime * Fs;%ilo�� wszystkich pr�bek
numberOfRMSWindows = allSamples/RMSwindow;
sampleTime = 1/Fs;
RMSwindowTime = RMSwindow * sampleTime;
time = RMSwindowTime:RMSwindowTime:endTime; %odpowiednie punkty czasu dla warto�ci RMS
%----------------KONIEC sta�ych-------------


%//////////////////////////////////////////////////generuj sygna� testowy
p = zeros(Fs*endTime,1); %inicjalizacja
amplitude = 0.1;
freq = 4e3;
for i = 1:endTime*Fs
    t = i * 1/Fs - 1/Fs;
    p(i) = amplitude * sin(freq*2*pi()*t);  
end
%///////////////////////////////////// koniec generacji sygna�u wzorcowego
%///////////////////////////////////// obliczanie RMS
inputRMS = zeros(numberOfRMSWindows,1);
for j = 1:numberOfRMSWindows%oblicz RMS
    for i = 1:RMSwindow
         sampleNumber = (j-1)*RMSwindow + i;%numer pr�bki
         inputRMS(j) = inputRMS(j) + p(sampleNumber)^2; %sumuj kwadrat pr�bek w oknie RMS
    end
   inputRMS(j) = sqrt(inputRMS(j));%RMS
   
end
%/////////////////////////////////////koniec obliczania RMS


%-------------START u�rednianie sygna�u dla sta�ej czasowej FAST:
last = 0; 
inputRMS_F = zeros(numberOfRMSWindows,1);
for j = 1:numberOfRMSWindows
   if j ~= 1,last = inputRMS_F(j - 1);end
   now = inputRMS(j);
   inputRMS_F(j) = (a*last+now)*b;
end
%-------------KONIEC u�rednianie sygna�u dla sta�ej czasowej FAST

%-------------START obliczanie poziomu d�wi�ku:
Lf = zeros(numberOfRMSWindows,1);
for j = 1:numberOfRMSWindows
    if inputRMS_F(j) < p0^2, Lf(j) = 0;
    else Lf(j) = 10 * log10(inputRMS_F(j)/p0^2); %poziom ci�nienia akustycznego u�redniony wg sta�ej czasowej F
    end
end
%-------------KONIEC obliczania poziomu d�wi�ku

figure;
subplot(111);
plot(time,Lf);
title('poziom ci�nienia akustycznego u�redniony wg sta�ej czasowej F');
xlabel('czas[s]');


%----------------------------Sprawdzanie odpowiedzi z danymi referencyjnymi
load('referenceData/conventionalMeterReference.mat');

%RMSwindowTime to najmniejszy czas jaki mo�na sprawdzi�
%co zawieraja poszczegolne kolumny danych referencyjnych:
TIME = 1;
OUTPUT = 2;
CLASS1_PLUS = 3;
CLASS1_MINUS = 4;
CLASS2_PLUS = 5;
CLASS2_MINUS = 6;

classOfMeter = 1;
indexTime = 1;
outputState = Lf(end); %ostatnia warto�� dla tego sygna�u to stan ustalony 
response = [];
checkedRef = [];
for t = time
  indexRef = 1;
  
   for ref = reference(:,TIME)'
       if ref == t*1000 %razy 1000 bo ref jest w milisekundach
         
           checkedRef = [checkedRef,ref];%dodaj do tablicy kolejn� warto�� czasu kt�r� sprawdzono
           
           resp = Lf(indexTime)-outputState;
           response = [response,resp];%dodaj do tablicy kolejn� warto�� odpowiedzi 
           
           %sprawdzanie klasy
           if classOfMeter == 1 &&...
              reference(indexRef,OUTPUT) + reference(indexRef,CLASS1_PLUS) < resp &&...
              reference(indexRef,OUTPUT) + reference(indexRef,CLASS1_MINUS) > resp
              classOfMeter = 2;
           end
           if classOfMeter == 2 &&...
              reference(indexRef,OUTPUT) + reference(indexRef,CLASS2_PLUS) < resp &&...
              reference(indexRef,OUTPUT) + reference(indexRef,CLASS2_MINUS) > resp
              classOfMeter = -1;
           end
       end
   indexRef = indexRef+1;
   end
   
   
indexTime = indexTime + 1;
end

checkedRef
response
if classOfMeter ~= -1
    string = ['b��dy w normie dla miernika klasy ',num2str(classOfMeter)];
    disp(string)
else
    string = ['b�edy wysz�y po za mo�liwe zakresy'];
    disp(string)
end

%plot(checkedRef,response);
%hold on;
%plot(reference(:,TIME),reference(:,OUTPUT));
%hold off;
%--------------------koniec sprawdzania odpowiedzi z danymi referencyjnymi



