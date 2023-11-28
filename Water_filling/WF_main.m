clc;
clear all;
close all;

rng(2022);

Nc=128;
n=10^5;
pow=2;
taps=2; %Rayleigh channel with 2 taps
%convLen = (Nc+Ncp)+taps-1; 
bits=randi([0,1],1,n);
lambda_r=0;%1/lambda(lagrange)

%snr in dB
snr=(-20:1:20);
%No=[];
sumwf=0;
sum_instant=zeros(1,Nc);
pow_star=zeros(1,Nc);
h= (randn(1,Nc) + 1i*randn(1,Nc))*sqrt(1/2);
for snrInd = 1:1:41
    No=1/(10^(snr(snrInd)/10)); %noise variance
    for i =1:1:Nc
        sum_instant(1,i)=(1/(10^(snr(snrInd)/10)))/((abs(h(i)))^2);
        sumwf= sumwf + (1/(10^(snr(snrInd)/10)))/((abs(h(i)))^2);
    end
    lambda_r=(sumwf+(Nc*pow))/Nc;%determination of lambda inverse
    for i =1:1:Nc
        pow_star(1,i)=max(0,(lambda_r-((1/(10^(snr(snrInd)/10)))/((abs(h(i)))^2))));%
    end
    


    snrLinear(snrInd) = 10^(snr(snrInd)/10); %snr in Linear scale
    [Tx] = QPSK_modulator(bits,n);
    for OFDMind = 1:Nc:n/2
        if OFDMind+Nc-1<n/2
         Tx_new=Tx(1,OFDMind:OFDMind+Nc-1);
        else
         Tx_new=zeros(1,Nc);
        end

        %CP insertion 
%ofdmSymbolsCP = [ofdmSymbols((Nff-Ncp+1):Nff) ofdmSymbols];

        OFDMTx= ifft(Tx_new,Nc);
        noise = (randn(1,Nc)+1i*randn(1,Nc))*sqrt(No/2); %complex noise
        OFDMRx = OFDMTx.*h.*sqrt(pow_star) + noise;
    
    %     ofdmRx = conv(h,ofdmSymbolsCP) + noise; %Received OFDM signal
    % 
    %     ofdmRx_cpr = ofdmRx(Ncp+1:convLen); %on removing cyclic prefix
    
        Rx_new = fft(OFDMRx,Nc);
        Rx(1,OFDMind:OFDMind+Nc-1)=Rx_new;
    end
    demodBits = QPSK_demodulator(Rx,length(Rx));
    demodBits = demodBits(1,1:n);
error(snrInd)=sum(demodBits~=bits)/n;   
end
semilogy(snr,error)
hold on 
xlabel('SNR in dB')
ylabel('BER')
title('BER vs SNR with waterfilling?')
grid on
