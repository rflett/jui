// server url
const serverBaseUrl = "https://api.staging.jaypi.online";
const socketBaseUrl = "ws://192.168.1.3:8080";

// account management
const signinUrl = "$serverBaseUrl/account/signin";
const signupUrl = "$serverBaseUrl/account/signup";

// oauth
const oauthUrl = "$serverBaseUrl/oauth";

// users
const userUpdateUrl = "$serverBaseUrl/user";
const userAvatarUrl = "$serverBaseUrl/user/avatar";
const userDeviceUrl = "$serverBaseUrl/user/device";
const userCreateVoteUrl = "$serverBaseUrl/user/vote";
const userDeleteVoteUrl = "$serverBaseUrl/user/vote";
const userGetUrl = "$serverBaseUrl/user";

// groups
const groupUrl = "$serverBaseUrl/group";
const groupJoinUrl = "$serverBaseUrl/group/members";

// misc
const searchUrl = "$serverBaseUrl/search";
const playedSongsUrl = "$serverBaseUrl/songs/played";
