import { Socket } from "phoenix";

let socket = new Socket(
  "/socket",
  { params: { token: "" } }
);

socket.connect()

// Now that you are connected, you can join channels with a topic:a
let channel = socket.channel(`game:lobby`, {}); 

let state = {
    ready: false,
    users: [],
    genres: [],
};

let callback = null;

function state_update(st) {
  console.log("New State", st)
  state = st;
  if (callback) {
    callback(st);
  }
}

export function ch_join(cb) {
  callback = cb;
  callback(state)
}

export function ch_waiting(user_id, playlist) {
  channel = socket.channel(`playlist:${playlist}`, {});

  channel.join()
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to join", resp)
    })

  channel.on("view", state_update);
}

export function ch_genres(genres) {
  console.log(channel)
  channel.push("genres", genres)
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to push", resp)
    });
}

export function ch_ready() {
  channel.push("ready", {})
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to push", resp)
    });
}

export default socket