clc;
clear all;
close all;

rng(2022);%what does this command do?

%no of bits
n=100000;
bits=zeros(1,n);
bitSequence=rand(1,n);
%generating bits
for i=1:n
    if bitSequence(i)<0.5
        bits(i)=1;
    end
end
Tx=[];
%Bits to Symbols
for ii=1:n
    if bits(ii)==1
        Tx(ii)=1;
    else
        Tx(ii)=-1;
    end
end
snr=(-20:1:20);


%non-coherent
a=1;
bitsa=ones(1,n/2)*a;
bitsb=ones(1,n/2)*a;

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
    
    
 

    
    noise = randn(1,length(Tx))*sqrt(No/2);
    noise_i =  randn(1,length(Tx))*sqrt(No/2);%confirm if complex noise needed here, and also magnitude of noise..
    
    %AWGN Channel
    rx_awgn = Tx + noise;
    
    %Coherent detection
    h_coherent = (randn(1,n) + 1i*randn(1,n))*sqrt(1/2);
    rx_coherent = h_coherent.*Tx + noise;
    
    %Non-coherent orthogonal 
 %demodulated_noncoherent=zeros(1,n);
    for j=1:n
        if abs(rx_noncoherent(1,j))<abs(rx_noncoherent(2,j))
            demodulated_noncoherent(j)=8;
        else
            demodulated_noncoherent(j)=7;
        end
    end

    %Detection

    %Coherent detection
    noise_coherent = conj(h_coherent).*(noise)./abs(h_coherent);
    rx_coherent_trans = conj(h_coherent).*((h_coherent).*Tx)./abs(h_coherent) + noise_coherent;
%     demod_coherent=zeros(1,n);
%     demod_awgn=zeros(1,n);
%     error_awgn=zeros(1,length(snr));
%     error_coherent=zeros(1,length(snr));

    for j=1:n
        if real(rx_coherent_trans(j))<=0
            demod_coherent(j)=0;
        else
            demod_coherent(j)=1;
        end
        if rx_awgn(j)<=0
            demod_awgn(j)=0;
        else
            demod_awgn(j)=1;
        end
    end

    error_awgn(snr_index) = sum(demod_awgn~=bits)/length(bits);
    error_coherent(snr_index) = sum(demod_coherent~=bits)/length(bits);
theoreticalPe_coherent(snr_index)=1/(4*((10^(snr(snr_index)/10))));
    if (theoreticalPe_coherent(snr_index)>0.5)
        theoreticalPe_coherent(snr_index)=0.5;
    end

theoreticalPe_awgn(snr_index)=1/(4*((10^(snr(snr_index)/10))));
    if (theoreticalPe_awgn(snr_index)>0.5)
        theoreticalPe_awgn(snr_index)=0.5;
    end
    %Detection non-coherent


    
    error_noncoherent(snr_index) = sum(modulated~=demodulated_noncoherent)/n;
theoreticalPe_noncoherent(snr_index)=1/(2*((10^(snr(snr_index)/10))));
    if (theoreticalPe_noncoherent(snr_index)>0.5)
        theoreticalPe_noncoherent(snr_index)=0.5;
    end
end

semilogy(snr,error_awgn)
hold on
semilogy(snr,error_coherent)
hold on
semilogy(snr,error_noncoherent)
title('all')
legend('awgn','coh','non-co')
grid on
figure(2)
semilogy(snr,theoreticalPe_coherent)
hold on
semilogy(snr,error_coherent)
title('coheret')
grid on
figure(3)
semilogy(snr,theoreticalPe_awgn)
hold on
title('awgn')
grid on
semilogy(snr,error_awgn)
figure(4)

hold on
semilogy(snr,theoreticalPe_noncoherent)
hold on
semilogy(snr,error_noncoherent)
title('non-coherent')
grid on
%legend('awgn','coherent','coherent theoretical','awgn theoretical','non-coherent','non-coherent theoretical')
grid on


