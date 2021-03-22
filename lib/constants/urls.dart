// server url
const serverBaseUrl = "https://api.staging.jaypi.online";

// account management
const loginUrl = "$serverBaseUrl/account/signin";
const registerUrl = "$serverBaseUrl/account/signup";

// oauth
const _oauthUrl = "$serverBaseUrl/oauth/%s";
const oauthLoginUrl = "$_oauthUrl/login";
const oauthRedirectUrl = "$_oauthUrl/redirect";

// users
const userUrl = "$serverBaseUrl/user";
const userAvatarUrl = "$userUrl/user/avatar";
const userDeviceUrl = "$userUrl/user/device";
const userVoteUrl = "$userUrl/user/vote";
const getUserUrl = "$userUrl/%s";

// groups
const groupUrl = "$serverBaseUrl/group";
const groupMembershipUrl = "$groupUrl/membership";
const getGroupUrl = "$groupUrl/%s";
const groupGameUrl = "$getGroupUrl/game";
const groupMembersUrl = "$getGroupUrl/members";
const groupQrUrl = "$getGroupUrl/qr";

// misc
const searchUrl = "$serverBaseUrl/search";
