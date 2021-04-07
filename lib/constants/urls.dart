// server url
const serverBaseUrl = "https://api.staging.jaypi.online";

// account management
const signinUrl = "$serverBaseUrl/account/signin";
const signupUrl = "$serverBaseUrl/account/signup";

// oauth
const _oauthUrl = "$serverBaseUrl/oauth/%s";
const oauthLoginUrl = "$_oauthUrl/login";
const oauthRedirectUrl = "$_oauthUrl/redirect";

// users
const userUpdateUrl = "$serverBaseUrl/user";
const userAvatarUrl = "$serverBaseUrl/user/avatar";
const userDeviceUrl = "$serverBaseUrl/user/device";
const userCreateVoteUrl = "$serverBaseUrl/user/vote";
const userDeleteVoteUrl = "$serverBaseUrl/user/vote/%s";
const userGetUrl = "$serverBaseUrl/user/%s";

// groups
const groupCreateUrl = "$serverBaseUrl/group";
const groupUrl = "$serverBaseUrl/group/%s";
const groupUpdateUrl = "$serverBaseUrl/group/%s";
const groupGetUrl = "$serverBaseUrl/group/%s";
const gameCreateUrl = "$serverBaseUrl/group/%s/game";
const gameUpdateUrl = "$serverBaseUrl/group/%s/game/%s";
const gameDeleteUrl = "$serverBaseUrl/group/%s/game/%s";
const groupGetMembersUrl = "$serverBaseUrl/group/%s/members?withVotes=";
const groupJoinUrl = "$serverBaseUrl/group/members";
const groupLeaveUrl = "$serverBaseUrl/group/%s/members";
const groupQrUrl = "$serverBaseUrl/group/%s/qr";

// misc
const searchUrl = "$serverBaseUrl/search";
