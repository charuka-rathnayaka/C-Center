const nodemailer = require("nodemailer");
const _transporter = new WeakMap();

class Email {
  constructor() {
    _transporter.set(
      this,
      nodemailer.createTransport({
        host: 'smtp.gmail.com',
        auth:{
          user:process.env.email,
          pass:process.env.emailpassword
        }
        }
      )
    );
  }

  send(to, subject, text, HtmlContent) {
      console.log(process.env.email,process.env.emailpassword);
    return new Promise((resolve) => {
      _transporter.get(this).sendMail(
        {
          from: "C Center",
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