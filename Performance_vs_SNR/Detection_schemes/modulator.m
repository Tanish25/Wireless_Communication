function [Tx,modulated_nonc]=modulator(bits,TxNonC,n)
    modulated_nonc=zeros(1,n);
    for j=1:n
        %Coherent and awgn modulation
        if bits(j)==1
            Tx(j)=1;
        else
            Tx(j)=-1;
        end
        %non-coherent modulation
        if (TxNonC(1,j))==0
            modulated_nonc(j)=8;
        else
            modulated_nonc(j)=7;
        end
    end

end

