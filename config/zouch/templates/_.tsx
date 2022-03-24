{{ if HasSuffix .Filename ".test.tsx" -}}
{{ $component := TrimSuffix .Filename ".test.tsx" | Base | UpperCamelCase -}}
import { render } from '@testing-library/react'
import { {{ $component }} } from './{{ $component }}';
{{ else -}}
{{ $component := TrimSuffix .Filename ".tsx" | Base | UpperCamelCase -}}
export const {{ $component }}: React.FC = () => {
  return <>{{ $component }}</>;
};
{{ end -}}
