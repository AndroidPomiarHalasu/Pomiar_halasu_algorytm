clear all;
load('referenceData\correctionFreqReference.mat');
FREQ = 1;
OUTPUT_A = 2;
OUTPUT_C = 3;
OUTPUT_Z = 4;


CLASS1_PLUS = 5;
CLASS1_MINUS = 6;
CLASS2_PLUS = 7;
CLASS2_MINUS = 8;


Fs = 44100;
endTime = 1;
time = 0:1/Fs:endTime -1/Fs;

%wspolczynniki obliczone przez plik: wspolczynniki_filtru.m
%wspolczynniki dla filtru A:
NominatorA =[ 0, 0.6176802025121519, -2.286696983318899, 2.96996095461427, -1.366503100406905, -0.1184897424606108, 0.1840486690599931];
DenominatorA =[ 1.0, -4.230795036663339, 7.034667191476869, -5.744974555071087, 2.336382960243767, -0.4225290975360197, 0.02724854641019449];
%wspolczynniki dla filtru C
NominatorC = [ 0, 0.5208882669567478, -0.880619200776424, 0.1985735259525217, 0.1611574078671544];
DenominatorC = [ 1.0, -2.345810334051762, 1.726346371746705, -0.4112672811692883, 0.03073707450846974];


%---------------------------------------sekwencja testowa START

counter = 1;
dbA = zeros(1,length(reference(:,1)));
dbC = zeros(1,length(reference(:,1)));
dbA_errors = zeros(1,length(reference(:,1)));
dbC_errors = zeros(1,length(reference(:,1)));
for freq = reference(:,1)' %pozwala na generacje sinusów o kolejnych czêstotliwoœciach z reference
    disp('inicjalizacja dla czestotliwosci'),freq
    
    %//////////////////////////////////////////////////generuj sygna³ testowy
  
    x = zeros(Fs*endTime,1); %inicjalizacja
    yA = zeros(Fs*endTime,1);
    yC = zeros(Fs*endTime,1);
    amplitude = 1;
    for i = 1:endTime*Fs
        t = i * 1/Fs - 1/Fs;
        x(i) = amplitude * sin(freq*2*pi()*t);  
    end
    %///////////////////////////////////// koniec generacji sygna³u testowego
     disp('sprawdzanie filtru dla zadanego sygna³u');
    %---------------------------START petla dzia³ania filtru na sygna³ 
    for n = 1:endTime*Fs
        %===========================filtr A====================
        if n < 7
            yA(n) = 0;
        else
            
            indx = 1;
            D = 0;
            for a=DenominatorA(2:end)
                D = D -(a*yA(n-indx));
                indx = indx + 1;
            end
            %nominator
            N = 0;
            indx = 0;
            for b=NominatorA
                N = N +(b*x(n-indx));
                indx = indx + 1;
            end
            yA(n) = N+D;
        end
       %=====================KONIEC filtr A====================
       %============================filtr C====================
       if n < 5
            yC(n) = 0;
       else           
            indx = 1;
            D = 0;
            for a=DenominatorC(2:end)
                D = D -(a*yC(n-indx));
                indx = indx + 1;
            end
            %nominator
            N = 0;
            indx = 0;
            for b=NominatorC
                N = N +(b*x(n-indx));
                indx = indx + 1;
            end
            yC(n) = N+D;
        end
       %=====================KONIEC filtr C====================
       
    end
    %od 6000 probki, poniewaz tam jest ustalony sygnal
    dbA(counter)  = db((rms(yA(6000:end))/rms(x)));
    dbC(counter) = db((rms(yC(6000:end))/rms(x)));

    counter = counter + 1;
    
end
   %-----------------------pomiary zgodnosci z rozporzadzeniem------
classOfFilterA = 1;
classOfFilterC = 1;
for i = 1:length(reference(:,FREQ)')
    %sprawdzanie klasy dla filtru A
    dbA_errors(i) = reference(i,OUTPUT_A)-dbA(i);
    dbC_errors(i) = reference(i,OUTPUT_C)-dbC(i);
    if classOfFilterA == 1 &&...
      (reference(i,OUTPUT_A) + reference(i,CLASS1_PLUS) < dbA(i) ||...
      reference(i,OUTPUT_A) + reference(i,CLASS1_MINUS) > dbA(i))
      classOfFilterA = 2;
    end
    if classOfFilterA == 2 &&...
      (reference(i,OUTPUT_A) + reference(i,CLASS2_PLUS) < dbA(i) ||...
      reference(i,OUTPUT_A) + reference(i,CLASS2_MINUS) > dbA(i))
      classOfFilterA = -1;
    end
    %sprawdzanie klasy dla filtru C
    if classOfFilterC == 1 &&...
      (reference(i,OUTPUT_C) + reference(i,CLASS1_PLUS) < dbC(i) ||...
      reference(i,OUTPUT_C) + reference(i,CLASS1_MINUS) > dbC(i))
      classOfFilterC = 2;
    end
    if classOfFilterC == 2 &&...
      (reference(i,OUTPUT_C) + reference(i,CLASS2_PLUS) < dbC(i) ||...
      reference(i,OUTPUT_C) + reference(i,CLASS2_MINUS) > dbC(i))
      classOfFilterC = -1;
    end
end

    if classOfFilterA ~= -1
        string = ['b³êdy w normie dla filtru A klasy ',num2str(classOfFilterA)];
        disp(string)
    else
        string = ['b³edy wysz³y po za mo¿liwe zakresy'];
        disp(string)
    end
    if classOfFilterC ~= -1
        string = ['b³êdy w normie dla filtru C klasy ',num2str(classOfFilterC)];
        disp(string)
    else
        string = ['b³edy wysz³y po za mo¿liwe zakresy'];
        disp(string)
    end
%--------------KONIEC   pomiary zgodnosci z rozporzadzeniem------
figure(1);
semilogx(reference(:,FREQ),dbA)
title('filtr A');
xlabel('freq [Hz]');
ylabel('ampl [dB]');
figure(2);
semilogx(reference(:,FREQ),dbC)
title('filtr C')
xlabel('freq [Hz]');
ylabel('ampl [dB]');

    %hold on;
   % plot(time,yA);
    
   % pause;

    %---------------------------KONIEC petla dzia³ania filtru na sygna³ 
