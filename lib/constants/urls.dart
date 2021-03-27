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
const userBaseUrl = "$serverBaseUrl/user";
const userAvatarUrl = "$userBaseUrl/user/avatar";
const userDeviceUrl = "$userBaseUrl/user/device";
const userCreateVoteUrl = "$userBaseUrl/user/vote";
const userDeleteVoteUrl = "$userBaseUrl/user/vote/%s";
const getUserUrl = "$userBaseUrl/%s";

// groups
const groupBaseUrl = "$serverBaseUrl/group";
const groupMembershipUrl = "$groupBaseUrl/membership";
const groupUrl = "$groupBaseUrl/%s";
const gameBaseUrl = "$groupUrl/game";
const gameModifyUrl = "$gameBaseUrl/%s";
const groupMembersUrl = "$groupUrl/members?withVotes=";
const groupQrUrl = "$groupUrl/qr";

// misc
const searchUrl = "$serverBaseUrl/search";
