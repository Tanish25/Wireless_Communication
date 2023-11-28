%QPSK modulator

function [Tx] = QPSK_modulator(Bits,n)

%function [signal_symbol_vector,bit_symbol_set,symbol_set] = my_modulator_lab(bits,order,shift,type,n,bits_per_symbol)

% generating symbols for PSK

%     angularSeparation = 2*pi/order;
%     index = 1:order;
%     symbol_set_temp = exp(1i*angularSeparation.*index);
%     avgEnergy = mean(abs(symbol_set_temp).^2);
%     %symSet = exp(1i*shift).*symbol_set_temp./sqrt(avgEnergy);
    symbols=[1+1i,-1+1i,-1-1i,1-1i];
    bitSet=[0,0;1,0;1,1;0,1];

%defining bit symbol set for BPSK and QPSK
% if order==2
%     bitSet = [0,1];
% end
% if order==4
%         bitSet=[0,0;1,0;1,1;0,1]';
% end 


    j=1;
    for i=1:2:n
        for k=1:4
            if bitSet(k,:)==Bits(1,i:i+1)
                Tx(j)=symbols(k);
            end
        end
        j=j+1;
    end