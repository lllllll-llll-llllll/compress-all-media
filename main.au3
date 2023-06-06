#include "file.au3"
#include "array.au3"

; first crawl over a directory recursively getting all the contents of specific filetypes (mp4, webm, etc)
$count = 0
$path = 'C:\Users\' & @username & '\Videos' ;set the starting directory
$mask = '*.mp4;*.webm;*.mkv;*.mov;*.m4v' ; target filestypes
$list = _FileListToArrayRec($path, $mask, 25, -3, 0, 2) ;change -3 to -x level of recursion to get contents within subfolders etc
_ArrayDelete($list, 0)

; we iterate through the files
for $i = 0 to ubound($list)-1 step 1

	ToolTip("")
	$file = $list[$i]
	$name = filename($file) ;full path without .ext
	$type = filetype($file) ;just the .ext


;	if filename is appended with "_c" then it has already been compressed and we skip
	if StringRight($name, 2) = '_c' then
		$count += 1
		ContinueLoop

	endif


;	if not, we compress it via ffmpeg and save with "_c" appended
	ToolTip ( $count & '/' &  ubound($list), 0, 0)  ;progress ui
	$in  = $file
	$out = $name & '_c' & '.mp4'  ; all files will be converted to mp4
	$c = 'ffmpeg -i ' & $in & ' -c:v libx264 -preset slow -crf 28 -c:a aac -b:a 128k ' & $out ;ffmpeg command to reencode videos to a smaller filesize. modify -crf x and -preset x to your preferences
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


; welete the original file
	filedelete($file)
	$count += 1

next




func filename($string)
	$split = stringsplit($string, '.', 2)
	_ArrayDelete($split, ubound($split) - 1)
	$join = _arraytostring($split, '.')
	return $join
endfunc


func filetype($string)
	$split = stringsplit($string, '.', 2)
	return $split[ubound($split) - 1]
endfunc

