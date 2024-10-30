highlight clear Tabs

setlocal noexpandtab

let g:ale_linters = {
\   'go': ['golangci-lint', 'gofmt', 'gopls', 'gosimple', 'govet']
\}
