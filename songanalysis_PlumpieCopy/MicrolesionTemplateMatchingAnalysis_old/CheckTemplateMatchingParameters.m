function [] = CheckTemplateMatchingParameters(ParameterFile, SyllableTemplateFile, NoteFileDir)

%============== Some common variables =====================================
OutputDir = '/home/raghav/MicrolesionAnalysisResults/';

FileSep = filesep;
if (OutputDir(end) ~= FileSep)
    OutputDir(end+1) = FileSep;
end
%==========================================================================

%====== Load and extract parameters =======================================
disp('Extracting parameters ...');
Parameters = MA_ParseParametersFile(ParameterFile);
if (~exist([OutputDir, Parameters.BirdName, '.NoteFiles'], 'dir'))
    disp('Creating output directory ...');
    mkdir(OutputDir, [Parameters.BirdName, '.NoteFiles']);
end
    
%==========================================================================

%======Now extract all the song file names=================================
disp('Extracting song file names ...');
% First for the pre-treatment days
for i = 1:Parameters.NoPreDays,
    disp(['Extracting song files for pre-treatment day #', num2str(i), ' ...']);
    Parameters.PreDirSongFileNames{i} = MA_ExtractSongFileNames(Parameters.PreDirSongFileList{i});
    Parameters.PreUnDirSongFileNames{i} = MA_ExtractSongFileNames(Parameters.PreUnDirSongFileList{i});
end

% Next for the post-treatment days
for i = 1:Parameters.NoPostDays,
    disp(['Extracting song files for post-treatment day #', num2str(i), ' ...']);    
    Parameters.PostDirSongFileNames{i} = MA_ExtractSongFileNames(Parameters.PostDirSongFileList{i});
    Parameters.PostUnDirSongFileNames{i} = MA_ExtractSongFileNames(Parameters.PostUnDirSongFileList{i});
end
%==========================================================================

%======Now load up note files with bout information =======================
% Load up note files which have bouts labelled with a 'B'. This has been
% done to get a better idea of consistency of song production.

disp('Loading up note files ...');

if (~isempty(NoteFileDir))
    % First for pre days
    for i = 1:Parameters.NoPreDays,
        disp(['   Pre Day #', num2str(i), ' - directed song ...']); 
        % First directed songs
        NoteFileDirCellArray = cellstr(char(ones(length(Parameters.PreDirSongFileNames{i}), 1)*double(NoteFileDir)));

        % using cellfun so that i iterate over each element of the cell array.
        % To use cellfun, all of the other inputs also have to be in the form
        % of cell arrays of the same length - so the previous three lines
        % convert file type, data dir and output dir - common parameters for
        % all of the files into cell arrays

        [Parameters.PreDirBoutOnsets{i}, Parameters.PreDirBoutOffsets{i}, Parameters.PreDirBoutLens{i}] = cellfun(@MA_LoadBoutNoteFiles, Parameters.PreDirSongFileNames{i}, NoteFileDirCellArray, 'UniformOutput', 0);

        % next undirected songs
        disp(['   Pre Day #', num2str(i), ' - undirected song ...']); 
        NoteFileDirCellArray = cellstr(char(ones(length(Parameters.PreUnDirSongFileNames{i}), 1)*double(NoteFileDir)));
        [Parameters.PreUnDirBoutOnsets{i}, Parameters.PreUnDirBoutOffsets{i}, Parameters.PreUnDirBoutLens{i}] = cellfun(@MA_LoadBoutNoteFiles, Parameters.PreUnDirSongFileNames{i}, NoteFileDirCellArray, 'UniformOutput', 0);
    end

    % Next for post days
    for i = 1:Parameters.NoPostDays,
        % First directed songs
        disp(['   Post Day #', num2str(i), ' - directed song ...']); 
        
        SlashIndex = find(Parameters.PostDataDir{i} == FileSep);
        NoteFileDirCellArray = cellstr(char(ones(length(Parameters.PostDirSongFileNames{i}), 1)*double(NoteFileDir)));

        % using cellfun so that i iterate over each element of the cell array.
        % To use cellfun, all of the other inputs also have to be in the form
        % of cell arrays of the same length - so the previous three lines
        % convert file type, data dir and output dir - common parameters for
        % all of the files into cell arrays

        [Parameters.PostDirBoutOnsets{i}, Parameters.PostDirBoutOffsets{i}, Parameters.PostDirBoutLens{i}] = cellfun(@MA_LoadBoutNoteFiles, Parameters.PostDirSongFileNames{i}, NoteFileDirCellArray, 'UniformOutput', 0);

        % next undirected songs
        disp(['   Post Day #', num2str(i), ' - undirected song ...']); 
        NoteFileDirCellArray = cellstr(char(ones(length(Parameters.PostUnDirSongFileNames{i}), 1)*double(NoteFileDir)));
        [Parameters.PostUnDirBoutOnsets{i}, Parameters.PostUnDirBoutOffsets{i}, Parameters.PostUnDirBoutLens{i}] = cellfun(@MA_LoadBoutNoteFiles, Parameters.PostUnDirSongFileNames{i}, NoteFileDirCellArray, 'UniformOutput', 0);
    end
end
%==========================================================================

disp('Loading syllable templates ...');
if (exist('SyllableTemplateFile', 'var'))
    Parameters.SyllableTemplateFileName = SyllableTemplateFile;
end

Parameters.SyllableTemplate = load(Parameters.SyllableTemplateFileName);

TemplateMatchOutputDir = '/data/raghav/HVC_Microlesions_Paper/Test_TemplateMatching/';
[SyllableTemplateDir, SyllableTemplateFileName, SyllableTemplateExt] = fileparts(Parameters.SyllableTemplateFileName);

TemplateMatchOutputDir = [TemplateMatchOutputDir, SyllableTemplateFileName, SyllableTemplateExt, '.TemplateMatchResults'];
if (~exist(TemplateMatchOutputDir, 'dir'))
    mkdir(TemplateMatchOutputDir);
end

for SyllTemp = 1:length(Parameters.SyllableTemplate.SyllableTemplates),
    if (~exist([TemplateMatchOutputDir, FileSep, 'Syll_', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label], 'dir'))
        mkdir([TemplateMatchOutputDir, FileSep, 'Syll_', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label]);
    end
end

disp('Doing template matching ...');

for SyllTemp = 1:length(Parameters.SyllableTemplate.SyllableTemplates),

    disp(['   Syllable ', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label]);
    % First for pre song
    for i = 1:Parameters.NoPreDays,
        % next undirected songs
        Label = ['Syll_', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label];
        TemplateType = 'Spectrogram';
        SyllableTemplate = Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{min([3, length(Parameters.SyllableTemplate.SyllableTemplates{SyllTemp})])};
        disp(['      Pre Day #', num2str(i), ' - undirected song ...']); 
        MA_TemplateMatch_WithBoutLens(Parameters.PreDataDir{i}, Parameters.PreUnDirSongFileNames{i}{1}, Parameters.FileType, SyllableTemplate, Label, TemplateMatchOutputDir, TemplateType, Parameters.PreUnDirBoutOnsets{i}{1}, Parameters.PreUnDirBoutOffsets{i}{1});
    end
end

%============= Shuffled song comparisons with template ====================
TemplateMatchOutputDir = '/data/raghav/HVC_Microlesions_Paper/Test_TemplateMatching/ShuffledSongComparisons/';
[SyllableTemplateDir, SyllableTemplateFileName, SyllableTemplateExt] = fileparts(Parameters.SyllableTemplateFileName);

TemplateMatchOutputDir = [TemplateMatchOutputDir, SyllableTemplateFileName, SyllableTemplateExt, '.TemplateMatchResults'];
if (~exist(TemplateMatchOutputDir, 'dir'))
    mkdir(TemplateMatchOutputDir);
end

for SyllTemp = 1:length(Parameters.SyllableTemplate.SyllableTemplates),
    if (~exist([TemplateMatchOutputDir, FileSep, 'Syll_', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label], 'dir'))
        mkdir([TemplateMatchOutputDir, FileSep, 'Syll_', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label]);
    end
end

disp('Doing shuffled song template matching ...');

% Only for one pre undir song day

for SyllTemp = 1:length(Parameters.SyllableTemplate.SyllableTemplates),
    disp(['   Syllable ', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label]);

    disp(['      Pre Day #', num2str(i), ' - undirected song ...']); 

    NumberofFiles = 1;
    RandomFiles = Parameters.PreUnDirSongFileNames{1}(1:NumberofFiles);

    FileTypeCellArray = cellstr(char(ones(length(RandomFiles), 1)*double(Parameters.FileType)));
    RawDataDirCellArray = cellstr(char(ones(length(RandomFiles), 1)*double(Parameters.PreDataDir{1})));
    OutputDirCellArray = cellstr(char(ones(length(RandomFiles), 1)*double([TemplateMatchOutputDir, FileSep, 'Syll_', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label])));
    LabelCellArray = cellstr(char(ones(length(RandomFiles), 1)*double(['Syll_', Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{1}.MotifTemplate(1).Label])));
    TemplateTypeCellArray = cellstr(char(ones(length(RandomFiles), 1)*double('Spectrogram')));
    SyllableTemplateCellArray = cell(size(RandomFiles));
    for j = 1:length(SyllableTemplateCellArray),
        SyllableTemplateCellArray{j} = Parameters.SyllableTemplate.SyllableTemplates{SyllTemp}{min([3, length(Parameters.SyllableTemplate.SyllableTemplates{SyllTemp})])};
    end
    % using cellfun so that i iterate over each element of the cell array.
    % To use cellfun, all of the other inputs also have to be in the form
    % of cell arrays of the same length - so the previous three lines
    % convert file type, data dir and output dir - common parameters for
    % all of the files into cell arrays
    cellfun(@MA_RandomTemplateMatch_WithBoutLens, RawDataDirCellArray, RandomFiles, FileTypeCellArray, SyllableTemplateCellArray, LabelCellArray, OutputDirCellArray, TemplateTypeCellArray, Parameters.PreUnDirBoutOnsets{1}(1:NumberofFiles), Parameters.PreUnDirBoutOffsets{1}(1:NumberofFiles), 'UniformOutput', 0);
end

%==========================================================================