import {
  Controller,
  Post,
  Body,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { ApplyService } from './apply.service';
import { ApplyDto } from './apply.dto';

@Controller('api')
export class ApplyController {
  constructor(private readonly applyService: ApplyService) {}

  @Post('apply')
  async apply(@Body() body: ApplyDto) {
    try {
      await this.applyService.sendApplication(body);
      return { success: true, message: 'Candidature envoyée avec succès.' };
    } catch (error) {
      throw new HttpException(
        "Erreur lors de l'envoi. Veuillez réessayer.",
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
