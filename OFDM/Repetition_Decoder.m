%Repetition decoding

function [decBits] = Repetition_Decoder(bits,L)
k=1;
i=1;
for j=1:length(bits)
    decBits(k)=mean(bits(1,i:i+L-1));
    if(decBits(k)<=0.5)
        decBits(k)=0;
    else
        decBits(k)=1;
    end
    i=i+L;
    k=k+1;
end