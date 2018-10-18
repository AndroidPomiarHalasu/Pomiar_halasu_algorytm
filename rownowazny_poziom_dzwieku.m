%algorytm nie stosuje korekcji A

clear all;

%-----------------START sta³e-------------
endTime = 1; %dlugoœæ sygna³u w sekundach

p0 = 2e-5; %ciœnienie odniesienia
Fs = 48000; %czêstotliwoœæ próbkowania

RMSwindow = 240;%okno rms (iloœæ próbek)

allSamples = endTime * Fs;%iloœæ wszystkich próbek
numberOfRMSWindows = allSamples/RMSwindow;
sampleTime = 1/Fs;
RMSwindowTime = RMSwindow * sampleTime;
time = RMSwindowTime:RMSwindowTime:endTime; %odpowiednie punkty czasu dla wartoœci RMS
%----------------KONIEC sta³ych-------------


%//////////////////////////////////////////////////generuj sygna³ testowy
p = zeros(Fs*endTime,1); %inicjalizacja
amplitude = 0.1;
freq = 4e3;
for i = 1:endTime*Fs
    t = i * 1/Fs - 1/Fs;
    p(i) = amplitude * sin(freq*2*pi()*t);  
end
%///////////////////////////////////// koniec generacji sygna³u wzorcowego
%///////////////////////////////////// obliczanie RMS
inputRMS = zeros(numberOfRMSWindows,1);
for j = 1:numberOfRMSWindows%oblicz RMS
    for i = 1:RMSwindow
         sampleNumber = (j-1)*RMSwindow + i;%numer próbki
         inputRMS(j) = inputRMS(j) + p(sampleNumber)^2; %sumuj kwadrat próbek w oknie RMS
    end
   inputRMS(j) = sqrt(inputRMS(j));%RMS
   
end
%/////////////////////////////////////koniec obliczania RMS

%--------------------------------------START równowa¿ny poziom dŸwiêku 
observationTime = 3; %czas obserwacji
observationSamples = floor(observationTime * Fs); %iloœæ próbek przypadaj¹ca na czas obserwacji, zaokr¹glenie w dó³
sampleTime = 1/Fs; %czas trwania jednej próbki
numberOfIntergations = floor(length(inputRMS)/observationSamples); % iloœæ odddzielnych sca³kowanych wartoœci
Leq = zeros(numberOfIntergations,1);

sum=0;

for i = 1:numberOfRMSWindows
   
    if mod(i,observationSamples) == 0, sum = 0; end
    Lp = 10*log10((inputRMS(i)/p0)^2); %oblicz poziom dŸwiêku
    sum = sum  + sampleTime * 10^(0.1*Lp);
    
    if sum < p0^2, Leq(i) = 0;
    else
        Leq(i) = 10 * log10(sum/observationTime); %obliczanie poziomu równowa¿nego
    end
    
end




figure;
subplot(111);
plot(time,Leq);
xlabel('czas[s]');
ylabel('dB');
title('równowa¿ny poziom dŸwiêku');


%----------------------------Sprawdzanie odpowiedzi z danymi referencyjnymi
load('referenceData/integratingMeterReference.mat');

%RMSwindowTime to najmniejszy czas jaki mo¿na sprawdziæ
%co zawieraja poszczegolne kolumny danych referencyjnych:
TIME = 1;
OUTPUT = 2;
CLASS1_PLUS = 3;
CLASS1_MINUS = 4;
CLASS2_PLUS = 5;
CLASS2_MINUS = 6;

classOfMeter = 1;
indexTime = 1;
outputState = Leq(end); %ostatnia wartoœæ dla tego sygna³u to stan ustalony 
response = [];
checkedRef = [];
for t = time
  indexRef = 1;
  
   for ref = reference(:,TIME)'
       if ref == t*1000 %razy 1000 bo ref jest w milisekundach
         
           checkedRef = [checkedRef,ref];%dodaj do tablicy kolejn¹ wartoœæ czasu któr¹ sprawdzono
           
           resp = Leq(indexTime)-outputState;
           response = [response,resp];%dodaj do tablicy kolejn¹ wartoœæ odpowiedzi 
           
           %sprawdzanie klasy
           if classOfMeter == 1 &&...
              (reference(indexRef,OUTPUT) + reference(indexRef,CLASS1_PLUS) < resp ||...
              reference(indexRef,OUTPUT) + reference(indexRef,CLASS1_MINUS) > resp)
              classOfMeter = 2;
           end
           if classOfMeter == 2 &&...
              (reference(indexRef,OUTPUT) + reference(indexRef,CLASS2_PLUS) < resp ||...
              reference(indexRef,OUTPUT) + reference(indexRef,CLASS2_MINUS) > resp)
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
    string = ['b³êdy w normie dla miernika klasy ',num2str(classOfMeter)];
    disp(string)
else
    string = ['b³edy wysz³y po za mo¿liwe zakresy'];
    disp(string)
end

%plot(checkedRef,response);
%hold on;
%plot(reference(:,TIME),reference(:,OUTPUT));
%hold off;
%--------------------koniec sprawdzania odpowiedzi z danymi referencyjnymi





