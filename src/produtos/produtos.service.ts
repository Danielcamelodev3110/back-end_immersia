import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProdutosService {
  constructor(private prisma: PrismaService) {}

  async create(createProdutoDto: any) {
    // 🌟 Corrigido para 'registroCliente' (baseado no seu model RegistroCliente)
    const usuario = await this.prisma.registroCliente.findUnique({
      where: { id: createProdutoDto.id_cliente_produto },
    });

    if (!usuario) {
      throw new NotFoundException(
        'Usuário não encontrado para vincular ao produto.',
      );
    }

    // Cria o produto utilizando as propriedades exatas do seu schema
    return this.prisma.produto.create({
      data: {
        nome: createProdutoDto.nome,
        descricao: createProdutoDto.descricao,
        preco: createProdutoDto.preco,
        categoria: createProdutoDto.categoria || 'geral',
        imagem_url: createProdutoDto.imagem_url,
        quantidade_estoque: createProdutoDto.quantidade_estoque || 0,
        tipo_produto: createProdutoDto.tipo_produto,
        localizacao: createProdutoDto.localizacao,
        duracao: createProdutoDto.duracao,
        inclui: createProdutoDto.inclui,
        nao_inclui: createProdutoDto.nao_inclui,
        id_cliente_produto: createProdutoDto.id_cliente_produto,
      },
    });
  }

  async findAll() {
    return this.prisma.produto.findMany({
      include: {
        cliente: true, // 🌟 Se quiser puxar os dados do criador junto com o produto
      },
    });
  }

  async findOne(id: number) {
    const produto = await this.prisma.produto.findUnique({
      where: { id },
      include: {
        cliente: true,
      },
    });

    if (!produto) {
      throw new NotFoundException('Produto não encontrado.');
    }
    return produto;
  }

  // No seu produtos.service.ts
  async findMinhasHospedagens(idCliente: number) {
    return this.prisma.produto.findMany({
      where: {
        id_cliente_produto: idCliente,
        tipo_produto: 'hospedagem', // Filtra apenas o tipo hospedagem
      },
      orderBy: {
        data_criacao: 'desc',
      },
    });
  }
}
