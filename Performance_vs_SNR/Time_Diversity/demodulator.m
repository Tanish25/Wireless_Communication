function demod_TXD = demodulator(rx_TXD,n)
    for j=1:n
         if real(rx_TXD(j))<=0
            demod_TXD(j)=0;
         else
            demod_TXD(j)=1;
         end
    end
end