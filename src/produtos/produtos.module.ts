import { Module } from '@nestjs/common';
import { ProdutosController } from './produtos.controller';
import { ProdutosService } from './produtos.service'; // Ajuste o nome se for diferente
import { PrismaModule } from '../prisma/prisma.module'; // Se precisar do banco de dados nele

@Module({
  imports: [PrismaModule],
  controllers: [ProdutosController],
  providers: [ProdutosService], // Ajuste aqui conforme o nome do seu service do backend
})
export class ProdutosModule {}
