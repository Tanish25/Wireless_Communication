clc;
clear all;
close all;

rng(2022);

%no of bits
n=10^5;
% order = 4;
% shift=pi/4;
% numBits = log2(order);
%generating bits
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
% for ii=1:n
%     if bits(ii)==1
%         Tx(ii)=1;
%     else
%         Tx(ii)=-1;
%     end
% end

%snr in dB
snr=(-20:2:20);
for snr_index = 1:1:21

    %Modulation
    %function [Tx] = QPSK_modulator(bits,n);
    [Tx] = QPSK_modulator(bits,n);

    No=1/(10^(snr(snr_index)/10)); %noise variance
    noiseTx1 = sqrt(1/2).*(randn(1,n)+1i*randn(1,n))*sqrt(No/2);
    noiseTx2 = sqrt(1/2).*(randn(1,n)+1i*randn(1,n))*sqrt(No/2);
    noise_alamouti=[noiseTx1 noiseTx2];

  %% ALAMOUTI DESIGN
  
    %Alamouti known channel
    h1= (1+1i)*sqrt(1/2);
    h2= (-1-1i)*sqrt(1/2);
    norm_h=sqrt((abs(h1*h1) + abs(h2*h2)));
    
    Nind=1;


%% ALAMOUTI ENCODING FOR 2 TIME SLOTS

    rx_Alamouti_final=[];
    %loop over all QPSK symbols
    for sym=1:2:length(Tx)
        %Tx vectors
        Tx1=Tx(sym); 
        Tx2=Tx(sym+1); 
        
        %Matrices
        Alamouti_Matrix=[Tx1 (-1)*conj(Tx2);Tx2 conj(Tx1)];
        h_Matrix=[h1 h2];
        noise_matrix=[noise_alamouti(sym) noise_alamouti(sym+1)];

        %Alamouti
        rx_alamouti=h_Matrix*Alamouti_Matrix + noise_matrix;
        rx_alamouti(2)=conj(rx_alamouti(2));
        rx_Alamouti_final(sym)=[conj(h1) h2]*(rx_alamouti)';
        rx_Alamouti_final(sym+1)=[conj(h2) (-1)*h1]*(rx_alamouti)';
        Nind=Nind+2;
            
        
    
       
    
    end
    rx_Alamouti_final=rx_Alamouti_final/norm_h;
    
    
    %% RECEIVER BLOCK
demodBits = QPSK_demodulator(rx_Alamouti_final,length(rx_Alamouti_final));
error(snr_index)=sum(demodBits~=bits)/n;
end

%% PLOTTING 

semilogy(snr,error)
hold on 
xlabel('SNR in dB')
ylabel('BER')
title('BER vs SNR for Alamouti Scheme')
grid on