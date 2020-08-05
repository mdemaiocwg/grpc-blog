
clean:
	rm blog/blogpb/blog.pb.go
	rm -r blog-client/node_modules

gen:
	@protoc -I blog/ blog/blogpb/blog.proto --go_out=plugins=grpc:blog
	@mkdir -p blog-client/node_modules
	@protoc --proto_path=blog \
	--js_out=import_style=commonjs,binary:blog-client/node_modules/ \
	--grpc-web_out=import_style=commonjs,mode=grpcwebtext:blog-client/node_modules/ \
	blog/blogpb/blog.proto
