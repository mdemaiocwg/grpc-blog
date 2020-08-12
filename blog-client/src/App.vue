<template>
  <div id="app">
    <section>
      <span class="title-text">Blog gRPC Client</span>
      <div class="row justify-content-center mt-4">
        <input v-model="inputTitle" class="mr-5" placeholder="Blog Title">
        <input v-model="inputAuthor" class="ml-5" placeholder="Blog Author">
      </div>
      <div class="row justify-content-center mt-4">
          <textarea v-model="inputContent" class="mr-1" placeholder="Blog Content" rows="8" cols="80"></textarea>
        </div>
        <div class="row justify-content-center mt-4">
          <button @click="AddBlog" class="btn btn-primary">Add Blog</button>
        </div>
    </section>
    <section class="mt-5">
      <div class="row mb-5" v-for="i in Math.ceil(blogs.length / 3)">
          <ul class="list-group list-group-horizontal mr-5">
            <li
              class="row list-group-item border ml-5"
              v-for="blog in blogs.slice((i-1) * 3, i * 3)"
              v-bind:key="blog._id"
            >
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
   <footer class="footer">
    <a href="https://www.github.com/mdemaio/" class="footer-item" target="_blank">Github</a>
    <a href="https://www.linkedin.com/in/matthew-demaio-6848ab15a/" class="footer-item" target="_blank">Linkedin</a>
  </footer>
  </div>
</template>

<script>
const isDev = true;
import { ListBlogRequest, ReadBlogResponse, CreateBlogRequest, CreateBlogResponse, DeleteBlogRequest, Blog } from "../blogpb/blog_pb";
import { BlogServiceClient } from "../blogpb/blog_grpc_web_pb";
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";

export default {
  name: "app",
  components: {
  },
  data: function() {
    return {
      inputTitle: "",
      inputAuthor: "",
      inputContent: "",
      blogs: []
    };
  },
  created: function() {
    this.client = new BlogServiceClient("http://localhost:8080", null, null);
    this.ListBlog();
  },
  methods: {
    ListBlog: function() {
      if (!isDev){
      let getRequest = new ListBlogRequest();
      let stream = this.client.listBlog(getRequest, {});
      this.blogs = [];
      let blogs = this.blogs;
      stream.on('data', function(response){
        let resBlogs = response.getBlog();
        const protoTimeStamp = resBlogs.getCreatedTime();
        let jsDate = protoTimeStamp.toDate();
        jsDate = jsDate.toLocaleString();

        const blog = {_Id: resBlogs.getId(), Title: resBlogs.getTitle(), Content: resBlogs.getContent(), AuthorId: resBlogs.getAuthorId(), CreatedTime: jsDate};
        blogs.push(blog);
      });
      stream.on('end', function(end) {
        console.log("END OF STREAM!");
      });
      } else{
        for(var i = 0; i < 12; i++){
          const blog = {_Id: "TESTID", Title: "Matt Test Title", Content: "Matt testing content 123 123 123 Test 1234", AuthorId: "Matthew DeMaio", CreatedTime: "8/12/2020, 12:09:01 PM"};
          this.blogs.push(blog);
        }
      }
    },
    AddBlog: function() {
      let request = new CreateBlogRequest();
      let blog = new Blog();    
      blog.setAuthorId(this.inputAuthor);
      blog.setTitle(this.inputTitle);
      blog.setContent(this.inputContent);

      request.setBlog(blog);

      this.client.createBlog(request, {}, (err, response) => {
        this.ListBlog();
        console.log(response.getBlog().getId());
      });
    },
    DeleteBlog: function(blog) {
      let deleteRequest = new DeleteBlogRequest();
      deleteRequest.setBlogId(blog._Id);
      this.client.deleteBlog(deleteRequest, {}, (err, response) => {
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
   min-height:100%;
   position:relative;
}

.title-text {
  font-size: 35px;
}

.delete{
  cursor: pointer;
  color: red;
}

.author{
  font-style: italic;
}

.footer-item{
  color: black;
  font-size: 18px;
  font-weight:500;
  margin: 25px !important;
}

.footer {
 position: fixed;
 bottom: 0px;
 width: 100%;
 padding: 2px;
}

footer {
  background: #007bff;
  color: white;
  
}

ul > li{
  width: 30%;
  list-style: none;
  display: block;
  float: left;
}

ul{
  width: 100%;
}

body{
  margin: 0px;
}

html, 
body {
    height: 100%;
}
</style>
