{{ $uuid := ReplaceAll (Shell `uuidgen`) "-" "" -}}
{{ $file := ReplaceAll (.Filename | Base) "." "_" -}}
#ifndef INCLUDE_{{$file}}_{{$uuid}}
#define INCLUDE_{{$file}}_{{$uuid}}



#endif // INCLUDE_{{$file}}_{{$uuid}}
