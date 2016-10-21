function [RawData, Fs] = ASSLGetRawData(DirectoryName, FileName, FileType, SongChanNo)


SlashIndex = find((FileName == '/') | (FileName == '\'));
if (~isempty(SlashIndex))
    FileName = FileName(SlashIndex(end)+1:end);
end

FileSep = filesep;
if (DirectoryName(end) ~= FileSep)
    DirectoryName(end+1) = FileSep;
end

switch FileType
    case 'okrank'
        [RawData, Fs] = ReadOKrankData(DirectoryName, FileName, SongChanNo);
    
    case 'obs'
        [RawData, Fs] = soundin_copy(DirectoryName, FileName, 'obs');
        RawData = RawData * 5/32768;

    case 'wav'
        PresentDir = pwd;
        cd(DirectoryName);
        [RawData, Fs] = audioread(FileName);
        cd(PresentDir);
end
