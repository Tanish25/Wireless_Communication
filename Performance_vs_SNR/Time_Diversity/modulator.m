function Tx=modulator(bits,n)
    %Bits to Symbols
    for ii=1:n
        if bits(ii)==1
            Tx(ii)=1;
        else
            Tx(ii)=-1;   
        end
    end
end