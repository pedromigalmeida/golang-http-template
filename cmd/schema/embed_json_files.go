package schema

import "embed"

//go:embed *.json
var DynamoDbJsonFiles embed.FS
