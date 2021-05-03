{{ if HasSuffix .Filename "_test.go" -}}
package {{.Filename | Abs | Dir | Base}}_test

import (
	"testing"
)

func Test{{RegexReplaceAll .Filename `_test\.go$` "" | Base | UpperCamelCase}}(t *testing.T) {
}
{{ else -}}
package {{.Filename | Abs | Dir | Base}}
{{ end -}}
