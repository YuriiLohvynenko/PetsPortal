import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const chat_id = document.getElementById("chat_id").value;
  
  consumer.subscriptions.create({channel: "MessageChannel", chat_id: chat_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Channel Connected!!!");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      document.getElementById("messages").innerHTML += data.html
      
    }
  });
});