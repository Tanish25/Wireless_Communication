
clc;
clear all;
close all;

rng(2022);%what does this command do?

%no of bits
n=100000;
a=1;%non-coherent parameter
Tx=[];
snr=(-20:1:20);
[bits,TxNonC]=bit_generator(n,a);
[Tx,modulated_nonc]=modulator(bits,TxNonC,n);
for snr_index = 1:1:41
    No=1/(10^(snr(snr_index)/10));
    snrLinear(snr_index) = 10^(snr(snr_index)/10); %snr in Linear scale
    %non-coherent
    noisea = (randn(1,n)+1i*randn(1,n))*sqrt(No/2);%SNR is half in Non-coherent
    noiseb = (randn(1,n)+1i*randn(1,n))*sqrt(No/2);%SNR is half in Non-coherent
    %confirm about Noise variances
    noise_nonc=[noisea;noiseb];
    % noise = (randn(2,n)+1i*randn(2,n)*sqrt(No);
    h_coherent = (randn(1,n) + 1i*randn(1,n))*sqrt(1/2);
    %Non-coherent orthogonal 
    h_noncoherent = [h_coherent;h_coherent];
    rx_noncoherent = h_noncoherent.*TxNonC + noise_nonc;
    
    
 

    noise_coherent= (randn(1,length(Tx)) + 1i*randn(1,length(Tx)))*sqrt(No/2);
    noise = randn(1,length(Tx))*sqrt(No/2);
    %noise_i =  randn(1,length(Tx))*sqrt(No/2);%confirm if complex noise needed here, and also magnitude of noise..
    
    %AWGN Channel
    rx_awgn = Tx + noise;
    
    %Coherent detection
    h_coherent = (randn(1,n) + 1i*randn(1,n))*sqrt(1/2);
    Tx_coherent=h_coherent.*Tx;
    %noise_coherent = conj(h_coherent).*(noise)./abs(h_coherent);
    rx_coherent_trans = ((conj(h_coherent)).*(Tx_coherent+noise_coherent))/norm(h_coherent);
    %rx_coherent = h_coherent.*Tx + noise;

    [demod_coherent,demod_awgn,demodulated_noncoherent]=demodulator(rx_coherent_trans,rx_awgn,rx_noncoherent,n);

    error_awgn(snr_index) = sum(demod_awgn~=bits)/length(bits);
    error_coherent(snr_index) = sum(demod_coherent~=bits)/length(bits);
    error_noncoherent(snr_index) = sum(modulated_nonc~=demodulated_noncoherent)/n;


    theoreticalPe_coherent(snr_index)=1/(4*(1+((10^(snr(snr_index)/10)))));
        if (theoreticalPe_coherent(snr_index)>1)
            theoreticalPe_coherent(snr_index)=1;
        end

    theoreticalPe_awgn(snr_index)=1/(sqrt(2*10^(snr(snr_index)/10)));%qfunc(sqrt(2*10^(snr(snr_index)/10)));
        if (theoreticalPe_awgn(snr_index)>1)
            theoreticalPe_awgn(snr_index)=1;
        end
            
    theoreticalPe_noncoherent(snr_index)=1/(2*(1+(((10^(snr(snr_index)/10)/2)))));
        if (theoreticalPe_noncoherent(snr_index)>1)
            theoreticalPe_noncoherent(snr_index)=1;
        end
    end

semilogy(snr,error_awgn)
hold on
semilogy(snr,error_coherent)
hold on
semilogy(snr,error_noncoherent)
hold on
semilogy(snr,theoreticalPe_awgn)
hold on
semilogy(snr,theoreticalPe_coherent)
hold on
semilogy(snr,theoreticalPe_noncoherent)
hold on
legend('awgn','coherent','non-coherent','awgn theoretical','coherent theoretical','non-coherent theoretical')
grid on


