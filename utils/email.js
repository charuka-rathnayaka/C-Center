const nodemailer = require("nodemailer");
const config = require("config");
const _transporter = new WeakMap();

class Email {
  constructor() {
    _transporter.set(
      this,
      nodemailer.createTransport({
        host: "smtp.gmail.com",
        auth:{
          user:process.env.email,
          pass:process.env.email_password
        }
        }
      )
    );
  }

  send(to, subject, text, HtmlContent) {
    return new Promise((resolve) => {
      _transporter.get(this).sendMail(
        {
          from: `"C Center" `,
          to: to,
          subject: subject,
          text: text,
          html: HtmlContent,
        },
        (err, info) => {
          if (err) resolve({ err });
          resolve({ info });
        }
      );
    });
  }
}

module.exports = Email;


/* const email = new Email();
  const temp = await email.send(
    SOUser.result[0].email,
    "Service Order - Payment",
    "",
    htmlContent
  );*/