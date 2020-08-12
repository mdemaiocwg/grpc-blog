
clean:
	rm blog/blogpb/blog.pb.go
	rm -r blog-client/blogpb

gen:
	@protoc -I blog/ blog/blogpb/blog.proto --go_out=plugins=grpc:blog
	@mkdir -p blog-client/blogpb
	@protoc --proto_path=blog \
	--js_out=import_style=commonjs,binary:blog-client/ \
	--grpc-web_out=import_style=commonjs,mode=grpcwebtext:blog-client/ \
	blog/blogpb/blog.proto
