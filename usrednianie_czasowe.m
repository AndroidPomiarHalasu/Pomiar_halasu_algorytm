%generuj przebieg prostok¹tny, a póŸniej zastosuj uœrednianie czasowe
%skrypt testuj¹cy uœrednianie czasowe

%  f_rms = (24.0*last_f_rms + wartosc)*0.04;//dlaL=240; dla fp = 48000 
clear all;hold off;
allTime = 5; %czas okna obserwacji
time = 1.5;%czas trwania skoku jednostkowego
startTime = 2;
samples = 1000;
deltaTime = allTime/samples;

fast = 0.125;
slow = 1;


LOW = 0;
HIGH = 1;

signal = zeros(samples,1);
timeAvgSig = signal;
timeAvgSig2 = signal;

startSample = floor(startTime/deltaTime);
stopSample = floor((time+startTime)/deltaTime);

for sample = 1:samples
    if sample >= startSample && sample <= stopSample
        signal(sample) = HIGH;
    end 
end

%25 próbek na 0.125s
%a = 24;
b = 0.04;

a = (1-b)/b;
for sample = 1:samples
   if sample == 1, last = 0; last2 = 0; else
       last = timeAvgSig(sample - 1);
       last2 = timeAvgSig2(sample-1);
   end
   now = signal(sample);

   timeAvgSig2(sample) = (a*last2+now)*b;
   if sample-26 >= 1
       timeAvgSig(sample) = last + 1/26 * now - 1/26*signal(sample-26);
   else
       timeAvgSig(sample) = last + 1/26 * now;
   end
   
end







timeAxis = deltaTime:deltaTime:allTime;
plot(timeAxis,signal);
hold on;
plot(timeAxis,timeAvgSig);
plot(timeAxis,timeAvgSig2);
axis([0,allTime,-0.1,HIGH+1]);
legend('skok jednostkowy','usrednianie fast');