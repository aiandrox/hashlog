<template>
  <v-card
    class="mx-auto"
    max-width="300"
    flat
  >
    <v-list disabled>
      <v-subheader>STATUS</v-subheader>
      <v-list-item-group color="primary">
        <v-list-item>
          <!-- TODO: v-forを使う -->
          <v-list-item-icon>
            <v-icon>mdi-account</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ role }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item>
          <v-list-item-icon>
            <v-icon>mdi-earth</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ privacy }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-card>
  </v-container>
  </v-card>
</template>

<script>
export default {
  props: {
    role: {
      type: String,
      default: ''
    },
    privacy: {
      type: String,
      default: ''
    }
  }
}
</script>
