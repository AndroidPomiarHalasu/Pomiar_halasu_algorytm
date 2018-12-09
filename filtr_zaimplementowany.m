N = 0.6177 * z^-1 - 2.287 * z ^ -2 + 2.97 * z ^ -3 - 1.367 * z ^ - 4 - 0.1185 * z ^-5 + 0.184 * z^-6;
D = 1 - 4.231 * z^-1 + 7.035 * z ^ -2 - 5.745*z^-3 + 2.336*z^-4 - 0.4225 * z ^ - 5 + 0.02725*z^-6;
load('referenceData\correctionFreqReference.mat');
Fs = 44100;

endTime = 0.2;
time = 0:1/Fs:endTime -1/Fs;




%---------------------------------------sekwencja testowa START
for freq = reference(22:end,1)' %pozwala na generacje sinusów o kolejnych czêstotliwoœciach z reference
    disp('inicjalizacja dla czestotliwosci'),freq

    
    x = zeros(Fs*endTime,1); %inicjalizacja
    amplitude = 0.1;
    for i = 1:endTime*Fs
        t = i * 1/Fs - 1/Fs;
        x(i) = amplitude * sin(freq*2*pi()*t);  
    end
    %///////////////////////////////////// koniec generacji sygna³u testowego
     disp('sprawdzanie filtru dla zadanego sygna³u');
    %---------------------------START petla dzia³ania filtru na sygna³ 
    %y =  4.231 * y[n-1] - 7.035 * y[n-2] + 5.745*y[n-3] - 2.336*y[n-4] +
    %0.4225 *y[n-5] - 0.02725*y[n-6] +
    
    %0.6177*x[n-1] - 2.287*x[n-2] + 2.97*x[n-3] - 1.367*x[n-4] -
    %0.1185*x[n-5]+0.184*x[n-6];
    y = zeros(1,endTime*Fs);
    for n = 1:endTime*Fs
        
        if n == 1, y(n) = 0;
        elseif n == 2, y(n) = 0.6177*x(n-1); 
        elseif n == 3, y(n) = 4.231*y(n-1) + 0.6177*x(n-1) - 2.287*x(n-2); 
        elseif n == 4, y(n) = 4.231*y(n-1) -7.035*y(n-2) + ...
                          0.6177*x(n-1) - 2.287*x(n-2) + 2.97*x(n-3); 
        elseif n == 5, y(n) = 4.231*y(n-1) -7.035*y(n-2) + ...
                          5.745*y(n-3) +0.6177*x(n-1) - ...
                          2.287*x(n-2) + 2.97*x(n-3) - 1.367*x(n-4);
        elseif n == 6, y(n) = 4.231*y(n-1) -7.035*y(n-2) + ...
                          5.745*y(n-3) - 2.336*y(n-4)+ ...
                          0.6177*x(n-1) - 2.287*x(n-2) + ...
                          2.97*x(n-3) - 1.367*x(n-4) - 0.1185*x(n-5);
        else  y(n) = 4.231*y(n-1) -7.035*y(n-2) + ...
                          5.745*y(n-3) - 2.336*y(n-4) + 0.4225*y(n-5) - 0.02725*y(n-6)+ ...
                          0.6177*x(n-1) - 2.287*x(n-2) + ...
                          2.97*x(n-3) - 1.367*x(n-4) - 0.1185*x(n-5) + 0.184*x(n-6);
        end
    end
   
    scatter(time(1:end-1000),y(1:end-1000));
    hold on;
    %plot(time(1:end-3000),y(1:end-3000));
    
    
    pause;
    %---------------------------KONIEC petla dzia³ania filtru na sygna³ 
    
    
     disp(freq);

   
 end
%---------------------------------------sekwencja testowa KONIEC
