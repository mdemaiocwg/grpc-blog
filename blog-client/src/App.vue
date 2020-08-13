<template>
<div id="app">
    <!-- <section> -->
    <span class="title-text">Blog gRPC Client</span>
    <!-- AddForm.vue component -->
    <add-form></add-form>
    <section class="mt-5">
        <!-- This seems hacky :), maybe lets find a better way? -->
        <div class="row mb-5" v-for="i in Math.ceil(blogs.length / 3)">
            <ul class="list-group list-group-horizontal mr-5">
                <li class="row list-group-item border ml-5" v-for="blog in blogs.slice((i-1) * 3, i * 3)" v-bind:key="blog._id">
                    <div class="row justify-content-center">
                        <h1>{{blog.Title}}</h1>
                    </div>
                    <div class="row justify-content-center">
                        <span class="author">{{blog.AuthorId}} • </span>
                        <span class="author ml-1">{{blog.CreatedTime}}</span>
                    </div>
                    <div class="row justify-content-center mt-4">
                        <p>{{blog.Content}}
                        </p>
                    </div>
                    <div class="row justify-content-center mt-4">
                        <button @click="DeleteBlog(blog)" class="btn btn-danger">Delete Blog</button>
                    </div>
                </li>
            </ul>
        </div>
    </section>
    <!-- CustomFooter.vue component -->
    <custom-footer></custom-footer>
    <!-- end footer -->
</div>
</template>

<script>
const isDev = false;
import {
    ListBlogRequest,
    ReadBlogResponse,
    CreateBlogRequest,
    CreateBlogResponse,
    DeleteBlogRequest,
    Blog
} from "../blogpb/blog_pb";
import {
    BlogServiceClient
} from "../blogpb/blog_grpc_web_pb";
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";

export default {
    name: "app",
    components: {},
    data: function () {
        return {
            blogs: []
        };
    },
    created: function () {
        this.client = new BlogServiceClient("http://localhost:8080", null, null);
        this.ListBlog();
    },
    methods: {
        ListBlog: function () {
            if (!isDev) {
                let getRequest = new ListBlogRequest();
                let stream = this.client.listBlog(getRequest, {});
                this.blogs = [];
                let blogs = this.blogs;
                stream.on('error', function(err){
                    alert("Error loading blogs: " + err["message"]);
                });
                stream.on('data', function (response) {
                    let resBlogs = response.getBlog();
                    const protoTimeStamp = resBlogs.getCreatedTime();
                    let jsDate = protoTimeStamp.toDate();
                    jsDate = jsDate.toLocaleString();

                    const blog = {  // todo: Can we add an image to this and store in MongoDB?
                        _Id: resBlogs.getId(),
                        Title: resBlogs.getTitle(),
                        Content: resBlogs.getContent(),
                        AuthorId: resBlogs.getAuthorId(),
                        CreatedTime: jsDate
                    };
                    blogs.push(blog);
                });
                stream.on('end', function (end) {
                    console.log("END OF STREAM!");
                });
            } else {
                for (var i = 0; i < 12; i++) {  // Dev mode, append 12 fake records to see layout.
                    const blog = {
                        _Id: "TESTID",
                        Title: "Matt Test Title",
                        Content: "Matt testing content 123 123 123 Test 1234",
                        AuthorId: "Matthew DeMaio",
                        CreatedTime: "8/12/2020, 12:09:01 PM"
                    };
                    this.blogs.push(blog);
                }
            }
        },
        DeleteBlog: function (blog) {
            let deleteRequest = new DeleteBlogRequest();
            deleteRequest.setBlogId("blog._Id");
            this.client.deleteBlog(deleteRequest, {}, (err, response) => {
                if(err){
                    alert("Failed to delete record: " + err["message"]);
                    return;
                }
                this.ListBlog();
            });
            console.log("blog -> ", blog._Id);
        }
    }
};
</script>

<style>
#app {
    font-family: "Avenir", Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    height: 100%;
    min-height: 100%;
    position: relative;
}

.title-text {
    font-size: 35px;
}

.author {
    font-style: italic;
}

ul>li {
    width: 30%;
    list-style: none;
    display: block;
    float: left;
}

ul {
    width: 100%;
}

body {
    margin: 0px;
}

html,
body {
    height: 100%;
}
</style>
