<template>
<section>
    <form @submit="AddBlog">
    <div class="row justify-content-center mt-4">
        <input v-model="inputTitle" class="mr-5" placeholder="Blog Title" required>
        <input v-model="inputAuthor" class="ml-5" placeholder="Blog Author" required>
    </div>
    <div class="row justify-content-center mt-4">
        <textarea v-model="inputContent" class="mr-1" placeholder="Blog Content" rows="8" cols="80" required></textarea>
    </div>
    <div class="row justify-content-center mt-4">
        <input type="submit" class="btn btn-primary" value="Add Blog">
    </div>
    </form>
</section>
</template>

<script>
import {
    CreateBlogRequest,
    CreateBlogResponse,
    Blog
} from "../../blogpb/blog_pb";
import {
    BlogServiceClient
} from "../../blogpb/blog_grpc_web_pb";

export default {
    name: "AddForm",
    data: function () {
        return {
            inputTitle: "",
            inputAuthor: "",
            inputContent: ""
        };
    },
    methods: {
        AddBlog: function (e) {
            e.preventDefault(); // Prevent page refresh.
            const client = new BlogServiceClient("http://localhost:8080", null, null);
            let request = new CreateBlogRequest();
            let blog = new Blog();
            blog.setAuthorId(this.inputAuthor);
            blog.setTitle(this.inputTitle);
            blog.setContent(this.inputContent);

            request.setBlog(blog);

            client.createBlog(request, {}, (err, response) => {
                if(err){
                    alert("Error adding blog: " + err["message"]);
                    return;
                }
                this.ListBlog();
                this.inputAuthor = "";
                this.inputTitle = "";
                this.inputContent = "";
            });
        },
        ListBlog: function (){
            this.$parent.ListBlog();    // todo: Append new blog to existing list of blogs, no need to make a request to the backend.
        }
    }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->

<style scoped>

</style>
