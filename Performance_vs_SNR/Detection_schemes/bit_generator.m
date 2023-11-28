function [bits,TxNonC]=bit_generator(n,a)
    %awgn and coherent
    bits=zeros(1,n);
    bitSequence=rand(1,n);
    %generating bits
    for i=1:n
        if bitSequence(i)<0.5
            bits(i)=1;
        end
    end
    
    %non-coherent transmission bit-vectors generation
    
    bitsa=ones(1,n/2)*a;
    bitsb=ones(1,n/2)*a;
    
    Txa=[bitsa;zeros(1,n/2)];%this will be symbolised as 7
    Txb=[zeros(1,n/2);bitsb];%this will be symbolised as 8
    TxNonC=[Txa Txb];
end