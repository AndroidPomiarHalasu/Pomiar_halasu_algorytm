%generuj przebieg prostok¹tny, a póŸniej zastosuj uœrednianie czasowe
%skrypt testuj¹cy uœrednianie czasowe

%  f_rms = (24.0*last_f_rms + wartosc)*0.04;//dlaL=240; dla fp = 48000 
clear all;hold off;
allTime = 5; %czas okna obserwacji
time = 1.5;%czas trwania skoku jednostkowego
startTime = 2;
samples = 48000;
allSamples = allTime * samples;
deltaTime = allTime/allSamples;


fast = 0.125;
slow = 1;
p0 = 2e-5;
RMSwindow = 200;%okno rms w iloœci próbek
numberOfRMSWindows = allSamples/RMSwindow;

LOW = 0;
HIGH = 0.1;

signal = zeros(allSamples,1);
timeAvgSig = zeros(numberOfRMSWindows,1);


startSample = floor(startTime/deltaTime);
stopSample = floor((time+startTime)/deltaTime);

for sample = 1:allSamples
    if sample >= startSample && sample <= stopSample
        signal(sample) = HIGH;
    end 
end

signalRMS = zeros(numberOfRMSWindows,1);

for sample = 1:numberOfRMSWindows%oblicz RMS
    
    for i = 1:RMSwindow
         signalRMS(sample) = signalRMS(sample) + signal((sample-1)*RMSwindow + i)^2; %sumuj kwadrat próbek w oknie RMS
    end
   signalRMS(sample) = sqrt(signalRMS(sample));%RMS
   
end

%25 próbek na 0.125s
%a = 24;
b = 0.04;

a = (1-b)/b;
for sample = 1:numberOfRMSWindows%F_RMS
   if sample == 1, last = 0; else
       last = timeAvgSig(sample - 1);
   end
   now = signalRMS(sample);

   timeAvgSig(sample) = (a*last+now)*b;
end

Lf = timeAvgSig;
for sample = 1:numberOfRMSWindows
   Lf(sample) = 10 * log10(timeAvgSig(sample)/p0^2);
    
end






timeAxis = deltaTime:deltaTime:allTime;
plot(Lf);
hold on;
%plot(timeAvgSig);

%axis([0,allTime,-0.1,HIGH+1]);
legend('skok jednostkowy','usrednianie fast');