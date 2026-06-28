import { Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { ApplyDto } from './apply.dto';

@Injectable()
export class ApplyService {
  constructor(private readonly mailer: MailerService) {}

  async sendApplication(body: ApplyDto) {
    await this.mailer.sendMail({ 
      to: process.env.MAIL_TO ?? 'hi@selys-africa.com',
      cc: process.env.MAIL_CC ?? 'apastes@selys-africa.com',
      subject: `Candidature Managing Director Guinée — ${body.name}`,
      html: `
        <h2>Candidature : ${body.name}</h2>
        <p><b>Email :</b> ${body.email}</p>
        <p><b>Téléphone :</b> ${body.phone}</p>
        <p><b>Expérience :</b> ${body.experience}</p>
        <hr>
        <h3>Note de motivation</h3>
        <p>${body.message.replace(/\n/g, '<br>')}</p>
      `,
    });
  }
}
