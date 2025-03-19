import consumer from "channels/consumer"

consumer.subscriptions.create("ProgressChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    console.log(data);

  }
});