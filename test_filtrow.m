clear all;
%wspczynniki filtrów wziête po obliczeniu plikiem "wspoczynniki_filtru.m"
load('referenceData\correctionFreqReference.mat');
load('modeleFiltrow\probkowanie_48000\filtrA_ss.mat')
load('modeleFiltrow\probkowanie_48000\filtrC_ss.mat')

[aMag,aPhase,aOmega] = bode(aModel,reference(:,1)'*2 * pi());
[cMag,cPhase,cOmega] = bode(cModel,reference(:,1)'*2 * pi());

%popraw u³o¿enie danych
aMag = aMag(:);aPhase = aPhase(:);aOmega = aOmega(:);
cMag = cMag(:);cPhase = cPhase(:);cOmega = cOmega(:);



FREQ = 1;
OUTPUT_A = 2;
OUTPUT_C = 3;
OUTPUT_Z = 4;


CLASS1_PLUS = 5;
CLASS1_MINUS = 6;
CLASS2_PLUS = 7;
CLASS2_MINUS = 8;
classOfFilterA = 1;classOfFilterC = 1;
display('czêstotliwoœæ[Hz] | wartoœæ[dB] dla A | wartoœæ[dB] dla C')
for i = 1:length(reference(:,FREQ)')
    
    respA  = db(aMag(i));
    respC = db(cMag(i));

    string = strcat(num2str(aOmega(i)/(2*pi())),' | ',num2str(respA),...
        ' | ',num2str(respC)) ;
    
    disp(string);

    %sprawdzanie klasy dla filtru A
    if classOfFilterA == 1 &&...
      (reference(i,OUTPUT_A) + reference(i,CLASS1_PLUS) < respA ||...
      reference(i,OUTPUT_A) + reference(i,CLASS1_MINUS) > respA)
      classOfFilterA = 2;
    end
    if classOfFilterA == 2 &&...
      (reference(i,OUTPUT_A) + reference(i,CLASS2_PLUS) < respA ||...
      reference(i,OUTPUT_A) + reference(i,CLASS2_MINUS) > respA)
      classOfFilterA = -1;
    end
    %sprawdzanie klasy dla filtru C
    if classOfFilterC == 1 &&...
      (reference(i,OUTPUT_C) + reference(i,CLASS1_PLUS) < respC ||...
      reference(i,OUTPUT_C) + reference(i,CLASS1_MINUS) > respC)
      classOfFilterC = 2;
    end
    if classOfFilterC == 2 &&...
      (reference(i,OUTPUT_C) + reference(i,CLASS2_PLUS) < respC ||...
      reference(i,OUTPUT_C) + reference(i,CLASS2_MINUS) > respC)
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








return
%-------------INNY SPOSÓB----------


Fs = 48000;

endTime = 0.2;
time = 0:1/Fs:endTime -1/Fs;




%---------------------------------------sekwencja testowa START
for freq = reference(:,1)' %pozwala na generacje sinusów o kolejnych czêstotliwoœciach z reference
    disp('inicjalizacja dla czestotliwosci'),freq
    
    aStates = zeros(6,1); aStatesNext = zeros(6,1);
    aOutput = zeros(Fs*endTime,1);
    cStates = zeros(6,1); cStatesNext = zeros(6,1); 
    cOutput = zeros(Fs*endTime,1);
    %//////////////////////////////////////////////////generuj sygna³ testowy
   
   
    
    p = zeros(Fs*endTime,1); %inicjalizacja
    amplitude = 0.1;
    for i = 1:endTime*Fs
        t = i * 1/Fs - 1/Fs;
        p(i) = amplitude * sin(freq*2*pi()*t);  
    end
    %///////////////////////////////////// koniec generacji sygna³u testowego
     disp('sprawdzanie filtru dla zadanego sygna³u');
    %---------------------------START petla dzia³ania filtru na sygna³ 
    for i = 1:endTime*Fs
        i
        aStatesNext = aModel.a * aStates + aModel.b * p(i);
        aOutput(i) = aModel.c * aStates + aModel.d *p(i);
        aStates = aStatesNext;
    
    end
   
    scatter(time,aOutput);
    hold on;
    plot(time,p);
    pause;
    %---------------------------KONIEC petla dzia³ania filtru na sygna³ 
    
    
     disp(freq);

   
 end
%---------------------------------------sekwencja testowa KONIEC










