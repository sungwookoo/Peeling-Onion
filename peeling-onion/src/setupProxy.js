const { createProxyMiddleware } = require("http-proxy-middleware");

module.exports = function (app) {
  app.use(
    "/jenkins",
    createProxyMiddleware({
      target: "https://jenkins.ssafy.shop",
      changeOrigin: true,
      pathRewrite: {
        "^/jenkins": "",
      },
      logLevel: "debug",
    })
  );
};
