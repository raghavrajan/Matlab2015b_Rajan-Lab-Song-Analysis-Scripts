function [] = MakeFiltFiles(DirectoryName, FileList, FileType)

if (ispc)
    if (DirectoryName(end) ~= '\')
        DirectoryName(end+1) = '\';
    end
else
    if (DirectoryName(end) ~= '/')
        DirectoryName(end+1) = '/';
    end
end

Fid = fopen(FileList, 'r');
FileName = fgetl(Fid);

while(ischar(FileName(1)))
    [path_batchsongfile, soundfilename, ext, ver] = fileparts(FileName);   
    soundfile = [soundfilename, ext, ver];
    filt_file=fullfile(DirectoryName, [soundfile, '.filt']);
    if (strfind(FileType,'obs'))
        channel_string = strcat('obs',num2str(0),'r');
        [rawsong,Fs] = soundin_copy(DirectoryName, FileName, channel_string);
        % Convert to uV - 5V on the data acquisition is 32768
        rawsong = rawsong * 1/32768;
    else
        if (strfind(FileType,'wav'));
            [rawsong, Fs] = wavread(FileName);
        else 
            if (strfind(FileType, 'okrank'))
                [rawsong, Fs] = ReadOKrankData(DirectoryName, FileName, 1);
                rawsong = rawsong/10;
            end
        end
    end
    disp('filtering song...');
    filtsong=bandpass(rawsong, Fs, 300, 8000, 'butter');
    disp('saving filtered song...')
    write_filt(filt_file, filtsong, Fs);
    FileName = fgetl(Fid);
    clear filtsong rawsong;
end