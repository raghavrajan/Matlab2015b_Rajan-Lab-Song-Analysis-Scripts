function [] = ConvertOKrank_to_wav(DirectoryName, BirdName, Date)

if (ispc)
    if ~(DirectoryName(end) == '\')
        DirectoryName(end + 1) = '\';
    end
else
    if ~(DirectoryName(end) == '/')
        DirectoryName(end + 1) = '/';
    end
end

cd(DirectoryName);

FilesToConvert = dir([BirdName,'_',Date,'*']);

for i = 1:length(FilesToConvert),
    try
        [rawsong, Fs] = ReadOKrankData(DirectoryName, FilesToConvert(i).name, 0);
        rawsong = rawsong/10;
        temp = resample(rawsong,44100,32000);
        OutputFileName = [FilesToConvert(i).name,'.wav'];
        wavwrite(temp,44100,16,OutputFileName);
        disp(['Finished converting ',FilesToConvert(i).name]);
    catch
        disp(['Could not convert ',FilesToConvert(i).name]);
    end
end

disp(['Finished converting ',num2str(i),' files']);
