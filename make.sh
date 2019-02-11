mkdir -p lib/src/generated
protoc -I protos/ protos/werewolf.proto --dart_out=grpc:lib/src/generated
