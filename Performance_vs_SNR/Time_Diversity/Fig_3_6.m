clc;
clear all;
close all;
%L=3;
rng(2022);
for L=3:6
    %no of bits
    n=10000;
    bits=zeros(1,n);
    bitSequence=rand(1,n);
    %generating bits
    for i=1:n
        if bitSequence(i)<0.5
            bits(i)=1;
        end
    end
    Tx=[];
    rx_TD=[];
    Tx= modulator(bits,n);
    snr=(-20:1:20);
    for snr_index = 1:1:41
        No=1/(10^(snr(snr_index)/10));
        %noise = randn(L,length(Tx))*sqrt(No/2) + 1i*randn(L,length(Tx))*sqrt(No/2);
        %noise = randn(L,length(Tx))*sqrt(No/2);
        
        
        %Time diversity
        %h= randn(1,L*n) + 1i*randn(1,L*n);
        %h= (randn(L,n) + 1i*randn(L,n))*sqrt(1/2);
    % --------------------------------------------------   
        %noiseMatrix = transpose(conj(h))*noise;
        for i=1:n
            %h= (randn(L,1) + 1i*randn(L,1))*sqrt(1/2);
            h=[1;1;1]
            noise= (randn(L,1) + 1i*randn(L,1))*sqrt(No/2);
            Tx_TD=h*Tx(i)+noise;
            h_hermitian=(conj(h))';
            product=(h_hermitian*Tx_TD);
            norm_h=norm(h);
            rx_TD(i) = product/norm_h;
        end
        %noise_TXD= transpose(conj(h))*noise./norm(h);
        %rx_TXD = norm(h).*Tx + noise_TXD;
    
        %detection
        demod_TXD=demodulator(rx_TD,n);
   
    
        error_TXD(snr_index) = sum(demod_TXD~=bits)/length(bits);
        theoreticalPe(snr_index)=1/((4^L)*((10^(snr(snr_index)/10))^L));
%         if (theoreticalPe(snr_index)>0.5)
%             theoreticalPe(snr_index)=0.5;
%         end
    
    end
    
    semilogy(snr,error_TXD)
    hold on
%     semilogy(snr,theoreticalPe)
%     hold on
    legend('L=3','L=3 repetition','L=4','L=4 repetition','L=5','L=5 repetition','L=6','L=6 repetition')
%     legend('L= %f',L)
    
    grid on
end