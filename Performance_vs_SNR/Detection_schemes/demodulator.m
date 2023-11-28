function [demod_coherent,demod_awgn,demodulated_noncoherent]=demodulator(rx_coherent_trans,rx_awgn,rx_noncoherent,n)
    for j=1:n
        %coherent demodulation
        if real(rx_coherent_trans(j))<=0
            demod_coherent(j)=0;
        else
            demod_coherent(j)=1;
        end
        %awgn demodulation
        if rx_awgn(j)<=0
            demod_awgn(j)=0;
        else
            demod_awgn(j)=1;
        end
        %non-coherent demodulation
        if abs(rx_noncoherent(1,j))<abs(rx_noncoherent(2,j))
            demodulated_noncoherent(j)=8;
        else
            demodulated_noncoherent(j)=7;
        end
    end
end