import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // 👇 ADICIONE ESTA LINHA AQUI (Habilita o acesso para qualquer origem)
  app.enableCors();

  await app.listen(3000);
}
bootstrap();
