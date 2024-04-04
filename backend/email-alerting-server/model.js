const { SESClient, SendEmailCommand } = require("@aws-sdk/client-ses");

exports.alertSES = ([alertData]) => {
  const { alertname, pod } = alertData.labels;

  console.log(alertname, pod);

  let alertMessage = "";

  if (alertname && pod) {
    alertMessage = `Alert: ${alertname}. Reported from pod ${pod}.`;
  } else if (alertname && !pod) {
    alertMessage = "Alert: Alert contained no information";
  }

  const config = {
    region: "eu-west-2",
    credentials: {
      accessKeyId: process.env.ACCESS_KEY,
      secretAccessKey: process.env.SECRET_ACCESS_KEY,
    },
  };

  const client = new SESClient(config);

  const command = new SendEmailCommand({
    Source: process.env.SENDER_ADDRESS,
    Destination: {
      ToAddresses: [process.env.RECIPIENT_ADDRESS],
    },
    Message: {
      Subject: { Data: alertname, Charset: "UTF8" },
      Body: {
        Text: {
          Data: alertMessage,
          Charset: "UTF8",
        },
      },
    },
  });

  return client.send(command);
};
