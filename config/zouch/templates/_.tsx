{{ $component := TrimSuffix .Filename ".tsx" | Base | UpperCamelCase -}}
export const {{ $component }}: React.FC = () => {
  return <>{{ $component }}</>;
};
