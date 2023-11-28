clc;
clear all;
close all;

rng(2022);

%no of bits
n=100000;
a=5;
bitsa=ones(1,n/2)*a;
bitsb=ones(1,n/2)*a;
% bitSequencea=rand(1,n/2);
% bitSequenceb=rand(1,n/2);

Txa=[bitsa;zeros(1,n/2)];%this will be symbolised as 7
Txb=[zeros(1,n/2);bitsb];%this will be symbolised as 8
TxOverall=[Txa Txb];

%generating symbols(modulation)
modulated=zeros(1,n);
for i=1:n
    if (TxOverall(1,i))==0
        modulated(i)=8;
    else
        modulated(i)=7;
    end
end

snr=(-20:1:20);
theoreticalPe=zeros(1,length(snr));
for snr_index = 1:1:41
    No=1/(10^(snr(snr_index)/10));
    noisea = (randn(1,n)+1i*randn(1,n))*sqrt(No/2);
    noiseb = (randn(1,n)+1i*randn(1,n))*sqrt(No/2);
    %confirm about Noise variances
    noise=[noisea;noiseb];
    % noise = (randn(2,n)+1i*randn(2,n)*sqrt(No);
  
    %Non-coherent orthogonal 
    h_noncoherent = (randn(2,n) + 1i*randn(2,n))*0.707;
    rx_noncoherent = h_noncoherent.*TxOverall + noise;
    
    
 

    %Detection
%demodulated_noncoherent=zeros(1,n);
    for j=1:n
        if abs(rx_noncoherent(1,j))<abs(rx_noncoherent(2,j))
            demodulated_noncoherent(j)=8;
        else
            demodulated_noncoherent(j)=7;
        end
    end

    
    error_noncoherent(snr_index) = sum(modulated~=demodulated_noncoherent)/n;
theoreticalPe(snr_index)=1/(2*((10^(snr(snr_index)/10))));
    if (theoreticalPe(snr_index)>0.5)
        theoreticalPe(snr_index)=0.5;
    end
end

plot(snr,error_noncoherent)
hold on
plot(snr,theoreticalPe)
hold on
legend('non-coherent','non-coherent theoretical')

grid on

