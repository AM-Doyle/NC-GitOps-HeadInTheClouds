const { alertSES } = require("./model");

exports.postAlert = (req, res, next) => {
  alertSES(req.body)
    .then(() => {
      res.sendStatus(201);
    })
    .catch(next);
};
