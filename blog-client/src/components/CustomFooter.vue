<template>
<footer class="footer">
    <a href="https://www.github.com/mdemaio/" class="footer-item" target="_blank">Github</a>
    <a href="https://www.linkedin.com/in/matthew-demaio-6848ab15a/" class="footer-item" target="_blank">Linkedin</a>
</footer>
</template>

<script>
export default {
    name: "CustomFooter"
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->

<style scoped>
.footer-item {
    color: black;
    font-size: 18px;
    font-weight: 500;
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
</style>
