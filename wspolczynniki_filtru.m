clear all;
s = tf('s');
Fs = 48000;

%filtr A-----------------------
ka = 7.39705*10^9;
Na = ka*s^4;%licznik
Da = (s+129.4)^2 * (s+676.7)*(s+4636)*(s+76655)^2;%mianownik
Ha = Na/Da;
%koniec filtru A-----------------------
%filtr C-----------------------
kc = 5.91797*10^9;
Nc = kc*s^2;%licznik
Dc = (s+129.4)^2*(s+76655)^2;%mianownik
Hc = Nc/Dc;
%koniec filtru C-----------------------


%na dziedzinê dyskretn¹ A-----------------------
discreteA = c2d(Ha,1/Fs);
'model przestrzeni stanu dla ch-ki korek. A'
aModel = ss(discreteA)%model przestrzeni stanu
%-----------------------
%na dziedzinê dyskretn¹ C-----------------------
discreteC = c2d(Hc,1/Fs);
'model przestrzeni stanu dla ch-ki korek. C'
cModel = ss(discreteC)%model przestrzeni stanu
%-----------------------


opts = bodeoptions('cstprefs');
opts.FreqUnits = 'Hz';
%bodemag(discreteA,opts);
%bodemag(discreteC,opts);