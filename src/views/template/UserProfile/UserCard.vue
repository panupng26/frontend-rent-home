<template>
  <md-card class="md-card-profile">
      <div class="md-card-avatar">
        <img class="img" :src="image"/>
      </div>
    <md-card-content>
      <h4 class="card-title">{{ user.firstname }}  {{ user.lastname }}</h4>
      <b-button variant="primary" @click="handleImageUpload">
        อัพโหลดรูปภาพ
      </b-button>
    </md-card-content>
  </md-card>
</template>
<script>
export default {
  name: "user-card",
  props: {
    image: {
      type: String,
      required: true
    },
    user: {
      type: Object,
    }
  },
  data() {
    return {
      tempImageName: ''
    };
  },
  methods: {
    handleImageUpload() {
      const input = document.createElement("input");
      input.type = "file";
      input.accept = "image/*";
      input.addEventListener("change", (event) => {
        const file = event.target.files[0];
        if (file) {
          const formData = new FormData();
          formData.append("images", file);

          this.$axios
            .post(`${this.$API_URL}/uploadimage`, formData)
            .then((response) => {
              this.tempImageName = response.data.filepaths[0]
            })
            .catch((error) => {
              console.error("Image upload failed:", error);
            }).finally(() => {
              this.handleApiUpdateProfile()
            })
        }
      });
      input.click();
    },
    async handleApiUpdateProfile() {
      const headers = {
        headers: {
          token: localStorage.getItem('token')
        }
      }
      const bodyJson = {
        image_profile: this.tempImageName
      }
      await this.$axios.post(this.$API_URL + '/edit/imageprofile', bodyJson, headers).then((res) => {
        console.log('res: ', res)
      }).finally(() => {
        this.$emit('getProfile')
      })
    }
  }
};
</script>
<style>

</style>
