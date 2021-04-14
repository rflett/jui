// Initial loading route
const loadingRoute = "/";

// Logged out routes
const loginRoute = "/login";
const loginProviderRoute = "/login-provider";
const registerRoute = "/register";

// Logged in routes
const dashboardRoute = "/home";
// Nested logged in routes
const gameRoute = "$dashboardRoute/game";
const profileRoute = "$dashboardRoute/profile";

// These are the nested routes without the `/home` prepended
const gamePage = "/game";
const profilePage = "/profile";