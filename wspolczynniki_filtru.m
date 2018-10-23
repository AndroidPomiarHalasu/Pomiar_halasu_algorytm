clear all;
s = tf('s');
Fs = 44100;

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
syms z
discreteAdifferentForm = (0.6177 *z^5 - 2.287 *z^4 + 2.97*z^3 - 1.367 * z^2 - 0.1185 * z^ + 0.184)/...
                            (z^6 - 4.231 *z^5 + 7.035 * z^4 - 5.745 * z^3 + 2.336 * z^2 - 0.4225 * z + 0.02725);


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