{{ if HasSuffix .Filename "_test.go" -}}
package {{.Filepath | Dir | Base}}_test

import (
	"testing"
)

func Test{{TrimSuffix .Filename "_test.go" | Base | UpperCamelCase}}(t *testing.T) {
}
{{ else -}}
package {{.Filepath | Dir | Base}}
{{ end -}}
