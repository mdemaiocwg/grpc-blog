<template>
  <div id="app">
    <section>
      <span class="title-text">Blog gRPC Client</span>
      <div class="row justify-content-center mt-4">
        <input v-model="inputTitle" class="mr-1" placeholder="Blog Title">
        <input v-model="inputContent" class="mr-1" placeholder="Blog Content">
        <input v-model="inputAuthor" class="mr-1" placeholder="Blog Author">
        <button @click="AddBlog" class="btn btn-primary">Add Blog</button>
      </div>
    </section>
    <section>
      <div class="row">
        <div class="offset-md-3 col-md-6 mt-3">
          <ul class="list-group justify-content-center">
            <li
              class="row list-group-item border mt-2 col-xs-1"
              v-for="blog in blogs"
              v-bind:key="blog._id"
            >
              <div>
                <span>{{blog}}</span>
                 <span @click="DeleteBlog(blog)" class="offset-sm-1 col-sm-2 delete text-right">X</span>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import { ListBlogRequest, ReadBlogResponse, CreateBlogRequest, CreateBlogResponse, DeleteBlogRequest, Blog } from "../node_modules/blogpb/blog_pb";
import { BlogServiceClient } from "../node_modules/blogpb/blog_grpc_web_pb";
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";

export default {
  name: "app",
  components: {},
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
    //this.AddBlog();
    this.ListBlog();
  },
  methods: {
    ListBlog: function(id) {
      let getRequest = new ListBlogRequest();
      let stream = this.client.listBlog(getRequest, {});//, (err, response) => {
      //   let resBlogs = response.getBlog();
      //   const blog = {_Id: resBlogs.getId(), Title: resBlogs.getTitle(), Content: resBlogs.getContent(), AuthorId: resBlogs.getAuthorId()};
      //   this.blogs.push(blog);

      //   console.log(resBlogs.getId());
      //   console.log(resBlogs.getTitle());
      //   console.log(resBlogs.getContent());
      //   console.log(resBlogs.getAuthorId());

      //   console.log(err);
      // });
      this.blogs = [];
      let blogs = this.blogs;
      stream.on('data', function(response){
        let resBlogs = response.getBlog();
        const blog = {_Id: resBlogs.getId(), Title: resBlogs.getTitle(), Content: resBlogs.getContent(), AuthorId: resBlogs.getAuthorId()};
        blogs.push(blog);
      });
      stream.on('end', function(end) {
        console.log("END OF STREAM!");
      });
    },
    AddBlog: function() {
      let request = new CreateBlogRequest();
      let blog = new Blog();    //{id: "test", AuthorId: "Matt Test", Title: "Matt Test", Content: "Matt Test"}
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
  margin-top: 60px;
}

.title-text {
  font-size: 22px;
}
</style>
