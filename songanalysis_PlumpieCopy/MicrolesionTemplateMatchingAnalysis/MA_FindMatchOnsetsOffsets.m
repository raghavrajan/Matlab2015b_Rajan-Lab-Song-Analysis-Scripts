function [OnsetTime, OffsetTime] = MA_FindMatchOnsetsOffsets(Onsets, Offsets, TemplateMatchValues, TemplateLen, BoutLen)


OnsetTime = TemplateMatchValues(2) - 0.150;

if (OnsetTime < 0)
    OnsetTime = 0.001;
end

OffsetTime = TemplateMatchValues(2) + TemplateLen + 0.150;
if (OffsetTime > BoutLen)
    OffsetTime = BoutLen/1000;
end

%[MinVal, MinIndex] = min(abs(Onsets - TemplateMatchValues(2)*1000));


% if ((Onsets(MinIndex) - TemplateMatchValues(2)*1000) > 0.015)
%     if (MinIndex ~= 1)
%         OnsetTime = Onsets(MinIndex-1)/1000;
%     else
%         OnsetTime = Onsets(MinIndex)/1000;
%     end
% else
%     if ((Onsets(MinIndex) - TemplateMatchValues(2)*1000) < -0.15)
%         OnsetTime = TemplateMatchValues(2);
%     else
%         OnsetTime = Onsets(MinIndex)/1000;
%     end
% end
% 
% %OnsetTime = TemplateMatchValues(2);
% 
% [MinVal, MinIndex] = min(abs(Offsets - (TemplateMatchValues(2) + TemplateLen)*1000));
% if (MinIndex > length(Offsets))
%     OffsetTime = Offsets(end)/1000;
% else
%     OffsetTime = Offsets(MinIndex)/1000;
% end
% 
% if (OffsetTime <= OnsetTime)
%     OffsetTime = OnsetTime + TemplateLen;
% end
% 
% if ((OffsetTime - OnsetTime) > 2*TemplateLen)
%     OnsetTime = TemplateMatchValues(2) - 0.02;
%     OffsetTime = TemplateMatchValues(2) + TemplateLen + 0.02;
% end