<template>
<section>
    <div class="row justify-content-center mt-4">
        <input v-model="inputTitle" class="mr-5" placeholder="Blog Title" required>
        <input v-model="inputAuthor" class="ml-5" placeholder="Blog Author" required>
    </div>
    <div class="row justify-content-center mt-4">
        <textarea v-model="inputContent" class="mr-1" placeholder="Blog Content" rows="8" cols="80" required></textarea>
    </div>
    <div class="row justify-content-center mt-4">
        <button @click="AddBlog" class="btn btn-primary">Add Blog</button>
    </div>
</section>
</template>

<script>
export default {
    name: "AddForm"
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->

<style scoped>

</style>
