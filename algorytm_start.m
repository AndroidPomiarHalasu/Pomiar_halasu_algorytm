clear all;
addpath('A-weighting_filter');



[y,Fs] = audioread('applause.wav');

yFiltered = filterA(y, Fs);



plot(y)
hold on
plot(yFiltered)
%sound(y,Fs)%odtwórz 