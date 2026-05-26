import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { UsersModule } from './users/users.module';
import { ProdutosModule } from './produtos/produtos.module'; // 🌟 Alterado para o Módulo

@Module({
  imports: [
    PrismaModule,
    UsersModule,
    ProdutosModule, // 🌟 Injetado corretamente aqui como Module
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
